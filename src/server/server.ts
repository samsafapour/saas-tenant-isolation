import express from 'express';
import { tenantContextMiddleware } from './middleware/tenantContext.js';
import { requireRole } from './middleware/rbacGuard.js';

const app = express();
app.use(express.json());

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', service: 'local-services-saas-core' });
});

app.use('/api/v1', tenantContextMiddleware);

app.get('/api/v1/appointments', async (req, res) => {
  try {
    const client = req.tenantClient!;
    const result = await client.query('SELECT id, customer_name, service_title, price_cents, scheduled_at FROM appointments ORDER BY scheduled_at ASC;');
    res.json({
      tenantId: req.tenantId,
      total: result.rowCount,
      appointments: result.rows
    });
  } catch (err: any) {
    res.status(500).json({ error: 'QUERY_FAILED', details: err.message });
  }
});

app.delete('/api/v1/appointments/:id', requireRole(['admin', 'manager']), async (req, res) => {
  try {
    const client = req.tenantClient!;
    const { id } = req.params;
    const result = await client.query('DELETE FROM appointments WHERE id = $1 RETURNING id;', [id]);
    
    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Appointment not found or belongs to another tenant' });
    }

    res.json({ message: 'Appointment cancelled successfully', deletedId: id });
  } catch (err: any) {
    res.status(500).json({ error: 'DELETE_FAILED', details: err.message });
  }
});

const PORT = process.env.PORT || 3000;
if (process.env.NODE_ENV !== 'test') {
  app.listen(PORT, () => {
    console.log(`server running on port ${PORT}`);
  });
}

export default app;
