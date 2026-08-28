import { Request, Response, NextFunction } from 'express';

type AllowedRole = 'admin' | 'manager' | 'staff';

export function requireRole(allowedRoles: AllowedRole[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    const userRole = (req.header('x-user-role') as AllowedRole) || 'staff';
    req.userRole = userRole;

    if (!allowedRoles.includes(userRole)) {
      return res.status(403).json({
        error: 'FORBIDDEN_OPERATION',
        message: `Insufficient permissions. Required one of: [${allowedRoles.join(', ')}], Current: ${userRole}`
      });
    }

    next();
  };
}
