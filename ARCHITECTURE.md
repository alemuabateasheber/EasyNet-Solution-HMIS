# EasyNet Solution P.L.C. — Hospital Information System Architecture

## Recommended production architecture

EasyNet HIS is intentionally a **modular monolith** for the first production release:

```text
Browser / Mobile-ready Web UI
          |
       HTTPS
          |
      Reverse Proxy
          |
   React + Vite frontend
          |
      REST API / Express
          |
  Authentication + RBAC
          |
  Clinical domain services
          |
        Prisma ORM
          |
      PostgreSQL
```

Do not split into microservices until there is a measurable operational reason. A shared transactional database is the safer starting point for hospital workflows because registration, encounters, orders, results, medication, admissions and billing must remain consistent.

## Hospital core

```text
Patient / MRN
    |
    +-- Registration
    +-- Appointment
    +-- Encounter
          +-- Diagnosis
          +-- Clinical notes
          +-- Vitals
          +-- Laboratory orders/results
          +-- Radiology orders/reports
          +-- Prescriptions
          +-- Admission
          +-- Billing
    |
    +-- Medical record / documents
    +-- Insurance
```

## Modules

- Patient registration and master patient index
- Appointments and queue workflow
- OPD / encounters
- Emergency
- Inpatient / wards / beds / admission-discharge
- Nursing and vital signs
- Dermatology
- Pathology
- Laboratory
- Radiology
- Pharmacy and medication stock
- Surgery / theatre
- Maternity
- Blood bank foundation
- Billing and payments foundation
- Insurance foundation
- Medical records
- Inventory / procurement foundation
- Reports and analytics
- Users, roles, security and audit

## Production security boundary

Authorization is enforced on the API. Frontend controls are only usability features.

- HTTP-only authentication cookie
- Short-lived access session
- Strong JWT secret required at startup
- Role-based permissions
- Zod request validation
- Login throttling
- Audit trail for sensitive operations
- Request IDs for incident tracing
- Secure headers
- HTTPS required in production
- No default password in the application UI
- No fake data fallback when the API is unavailable

## Data integrity rules

Human-readable numbers use a database-backed `Sequence` model rather than row counts. This avoids duplicate patient/order numbers during concurrent registrations.

Medication dispensing uses an atomic stock condition inside a database transaction so two simultaneous dispensations cannot oversell available stock.

Admissions and bed assignment are transactional: the bed must be available before admission and is released on discharge.

## Deployment recommendation

For the first hospital deployment:

1. PostgreSQL with encrypted storage and automated backups.
2. EasyNet API as a stateless container with horizontal scaling available later.
3. Nginx or a managed HTTPS reverse proxy for TLS termination and frontend delivery.
4. Separate production secrets from the repository.
5. Automated database migrations during controlled deployment.
6. Daily encrypted backups plus periodic restore testing.
7. Centralized logs and monitoring.
8. Staging environment before production migration.
9. Least-privilege database and application accounts.
10. Formal hospital policy for user provisioning, access review, retention and incident response.
