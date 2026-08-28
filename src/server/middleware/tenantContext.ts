import { Request, Response, NextFunction } from 'express';
import { pool } from '../db.js';

export async function tenantContextMiddleware(req: Request, res: Response, next: NextFunction) {
  const tenantId = req.header('x-tenant-id');

  if (!tenantId) {
    return res.status(400).json({
      error: 'TENANT_HEADER_MISSING',
      message: 'x-tenant-id header is required to scope this operation.'
    });
  }

  // UUID validation for preventing SQL Injection
  const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
  if (!uuidRegex.test(tenantId)) {
    return res.status(400).json({
      error: 'INVALID_TENANT_ID',
      message: 'The provided tenant ID is not a valid UUID.'
    });
  }

  let client;
  try {
    client = await pool.connect();

    // set session variable in postgres for utlizing RLS
    await client.query(`SELECT set_config('app.current_tenant_id', $1, false);`, [tenantId]);

    req.tenantId = tenantId;
    req.tenantClient = client;

    res.on('finish', () => {
      if (req.tenantClient) {
        req.tenantClient.release();
      }
    });

    next();
  } catch (err) {
    if (client) client.release();
    return res.status(500).json({
      error: 'TENANT_CONTEXT_ERROR',
      message: 'Could not establish isolated tenant database session.'
    });
  }
}
