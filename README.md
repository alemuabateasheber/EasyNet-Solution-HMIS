# EasyNet Solution P.L.C. — Hospital Management Information System

**Smart Healthcare · Better Tomorrow**

EasyNet HIS is a production-oriented modular hospital information system foundation. It combines a React/Vite web application, Express API, Prisma ORM and PostgreSQL.

## Current production foundation

- Secure HTTP-only session authentication
- Role-based API authorization
- Patient master record / MRN generation
- Appointments
- Clinical encounters
- Diagnoses, clinical notes and vitals
- Laboratory orders/results/finalization
- Radiology orders/report workflow foundation
- Prescriptions and atomic pharmacy dispensing
- Ward/bed/admission/discharge foundation
- Billing/operational summary foundation
- Audit logging
- Hospital dashboard with live database statistics
- Database-backed sequences for safe identifiers
- Input validation and API error handling
- Production build configuration

## Docker quick start

Requirements: Docker Engine + Docker Compose v2.

From the project root, generate a private installation `.env` file first:

```bash
./setup-env.sh
```

Then build and start the stack:

```bash
docker compose up -d --build
```

Check the services:

```bash
docker compose ps
```

Seed the initial administrator and reference data. The Compose stack now passes `SEED_ADMIN_PASSWORD` into the API container securely from the project `.env`:

```bash
docker compose exec api npm run db:seed
```

The generated administrator is:

- Email: `admin@easynet.local`
- Password: printed once by `./setup-env.sh` and stored only in the local `.env` file.

Open `http://localhost:8080`.

`docker compose down` must be run from the same project directory after `.env` has been created, because Compose validates the required database and JWT secrets while parsing the stack.

For non-Docker development, configure `server/.env` from `server/.env.example`, then run `npm install`, `npm run db:deploy`, `npm run db:seed`, and `npm run dev`.

The web application uses `/api` and Vite proxies that path to the API during development.

## Production

Do not commit `.env` files. Use a secret manager or deployment environment variables. Put the application behind HTTPS. Use managed PostgreSQL or a properly backed-up PostgreSQL cluster. Test migration and restore procedures before the first clinical deployment.

## Scope note

This release contains the implemented core HIS workflows in this package. External/device-dependent capabilities such as full PACS/DICOM integration, analyzer interfaces, national/payer claim exchange, theatre anesthesia documentation, maternity partograph, procurement approvals and advanced finance require their respective validated integrations before clinical go-live.

## Ethiopian Insurance & Claims Workflow

The Insurance & Claims module supports configurable Ethiopian payer workflows for Community-Based Health Insurance (CBHI), Social Health Insurance (SHI), private and employer schemes. It includes payer/provider setup, patient membership policies, preauthorization, claim submission, adjudication statuses, approved amounts and patient responsibility, with audit logging.

The implementation intentionally does not hard-code an undocumented national electronic claim-file format. Payer-specific benefit packages, codes, contracts and submission integrations can be configured as the applicable Ethiopian payer publishes/mandates them.

## Ethiopian Billing & QR Payments
Billing now supports ETB invoices, outstanding balances, payment requests and payment reconciliation for TELEBIRR and CBE_BIRR provider adapters. Configure provider API/webhook credentials in `.env`. A QR renderer can be configured with `QR_RENDER_URL`; provider-returned QR URLs are preferred. A payment is counted as revenue only after a verified provider callback or authorized reconciliation.

## Ethiopian payment reconciliation
Billing supports ETB invoices, payment requests and provider adapters for TELEBIRR and CBE_BIRR. A QR request is never treated as revenue until a verified provider callback or authorized reconciliation creates a COMPLETED Payment. Provider API URLs/secrets must be supplied by the hospital's merchant contracts; no provider endpoint is fabricated by the application.

## 2026 Senior Engineering / Clinical Review Baseline

The current reviewed baseline applies an international hospital-navigation structure, data-driven permission-aware navigation, facility-timezone reporting, formal A4 management reports and CMS-branded receipts, security headers, PHI no-store API responses, transactional bed allocation, stronger clinical referential validation, and an international Unicode-capable UI font stack (`Noto Sans`, `Noto Sans Ethiopic`, then system fallbacks).

Standards alignment: the UI targets WCAG 2.2 accessibility practices; interoperability planning follows the current released HL7 FHIR R5 direction rather than unreleased R6 development content. This package uses Node.js 24 LTS as the container runtime baseline.

The system should still be validated against the hospital's clinical governance, privacy/security policies, local regulatory requirements, integration contracts, and production infrastructure before clinical go-live.

## Admission form behavior
The inpatient admission dialog requires a real active ward and an available bed selected from the database. Existing encounters are filtered to the selected patient and remain optional; the form can be cancelled via the Cancel button, Escape key, or clicking the backdrop.
