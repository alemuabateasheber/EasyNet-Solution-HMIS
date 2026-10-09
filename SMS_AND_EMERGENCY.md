# SMS notifications and Emergency doctor tasks

## SMS
EasyNet stores every SMS in `SmsMessage` with QUEUED/SENDING/SENT/DELIVERED/FAILED status. Laboratory and completed radiology results automatically queue a patient notification when the patient has a phone number. Manual notifications are available from `#notifications`.

Set `SMS_PROVIDER_URL` and optional `SMS_PROVIDER_TOKEN` to connect an outbound SMS gateway. The gateway receives JSON `{to,message,category,clientReference}` and should return HTTP 2xx; a `messageId` or `id` field is stored when returned.

Do not put a provider credential into frontend code.

## Emergency doctor tasks
Emergency staff/physicians can assign a task to an active PHYSICIAN or EMERGENCY user, optionally linking a patient and due time. Doctors can acknowledge, start and complete tasks. Every transition is audited.

Open `#emergency`.

## Users & Security
System administrators now have an **Add user** button and can create/edit/deactivate accounts. The Audit Log remains available as a separate tab.
