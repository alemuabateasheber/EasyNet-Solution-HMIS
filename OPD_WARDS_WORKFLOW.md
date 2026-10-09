# EasyNet HIS — OPD & Inpatient/Wards Workflow

## Outpatient / OPD
- Patient check-in creates a persistent OPD queue entry and a linked OPD encounter in one transaction.
- Queue states: WAITING, CALLED, IN_CONSULTATION, COMPLETED, CANCELLED, NO_SHOW.
- Priority: NORMAL, URGENT, STAT.
- Doctor assignment and notes.
- Completing/cancelling the queue synchronizes the linked encounter.
- Existing encounter workflow supports assessment, plan, diagnoses, clinical notes, vitals, laboratory, radiology and prescriptions.

## Inpatient / Wards
- Admission creates an admission and atomically occupies the selected bed.
- Active ward list and bed availability.
- Discharge/cancellation releases the occupied bed.
- Ward transfer atomically releases the current bed, occupies the destination bed, records the transfer, and updates the admission.
- Nursing tasks support patient/admission assignment, clinician assignment, priority, due time, instructions, and OPEN/IN_PROGRESS/COMPLETED/CANCELLED lifecycle.
- Existing inpatient encounter workflow remains linked to diagnoses, notes, vitals, laboratory, radiology, prescriptions and billing.

## Data safety
- All new workflows use PostgreSQL transactions for bed movement and OPD encounter/queue creation.
- Permission checks and audit logging are applied to all new mutations.
- Migration is forward-only; do not use `docker compose down -v` on a database containing hospital data.

## New routes
- `#outpatient`
- `#inpatient`
- `#ward-transfers`
- `#nursing-tasks`
