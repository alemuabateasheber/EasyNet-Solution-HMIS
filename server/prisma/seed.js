import 'dotenv/config';
import { PrismaClient, Role } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();
const password = process.env.SEED_ADMIN_PASSWORD;
if (!password || password.length < 12) throw new Error('SEED_ADMIN_PASSWORD must be set to a strong password (12+ chars).');

const departments = [
  ['ADMIN','Administration','Hospital administration and system management'],
  ['RECEP','Reception','Registration and front desk'],
  ['OPD','Outpatient Department','General outpatient care'],
  ['ER','Emergency Department','Emergency and urgent care'],
  ['WARD','Inpatient Services','Wards and inpatient care'],
  ['DERM','Dermatology Unit','Skin, hair and nail care'],
  ['PATH','Pathology Unit','Tissue and laboratory diagnosis'],
  ['LAB','Laboratory Unit','Tests and diagnostic services'],
  ['RAD','Radiology Unit','Medical imaging and reporting'],
  ['PHAR','Pharmacy Unit','Medicines and pharmaceutical care'],
  ['NURS','Nursing','Nursing and patient care'],
  ['MAT','Maternity','Maternal and newborn services'],
  ['SURG','Surgery','Operating theatre and surgical care'],
  ['BLOOD','Blood Bank','Blood and transfusion services'],
  ['BILL','Billing & Finance','Billing, payments and revenue'],
  ['INS','Insurance','Insurance and claims'],
  ['HIM','Medical Records','Health information management'],
  ['INV','Inventory & Procurement','Supplies and procurement']
];

const users = [
  ['admin@easynet.local','Alemu','Abate',Role.SYSTEM_ADMINISTRATOR],
  ['reception@easynet.local','Reception','User',Role.RECEPTIONIST],
  ['doctor@easynet.local','Clinical','Provider',Role.PHYSICIAN],
  ['nurse@easynet.local','Nursing','User',Role.NURSE],
  ['lab@easynet.local','Laboratory','User',Role.LABORATORY],
  ['radiology@easynet.local','Radiology','User',Role.RADIOLOGY],
  ['pharmacy@easynet.local','Pharmacy','User',Role.PHARMACY],
  ['billing@easynet.local','Billing','User',Role.BILLING],
  ['records@easynet.local','Medical','Records',Role.MEDICAL_RECORDS]
];

async function main() {
  for (const [code,name,description] of departments) await prisma.department.upsert({where:{code},update:{name,description,active:true},create:{code,name,description}});
  const passwordHash = await bcrypt.hash(password, 12);
  for (const [email,firstName,lastName,role] of users) await prisma.user.upsert({where:{email},update:{firstName,lastName,role,passwordHash,isActive:true},create:{email,firstName,lastName,role,passwordHash}});

  const lab = await prisma.department.findUniqueOrThrow({where:{code:'LAB'}});
  const rad = await prisma.department.findUniqueOrThrow({where:{code:'RAD'}});
  const wardDept = await prisma.department.findUniqueOrThrow({where:{code:'WARD'}});
  const pharmacy = await prisma.department.findUniqueOrThrow({where:{code:'PHAR'}});

  const labTests = [
    ['CBC','Complete Blood Count','Whole Blood','cells/uL','See laboratory reference range',150],
    ['GLU','Glucose','Serum','mg/dL','70-110',100],
    ['CRP','C-Reactive Protein','Serum','mg/L','0-5',180],
    ['URINALYSIS','Urinalysis','Urine',null,'See laboratory reference range',120]
  ];
  for (const [code,name,specimenType,unit,referenceRange,price] of labTests) await prisma.labTest.upsert({where:{code},update:{name,specimenType,unit,referenceRange,price,active:true},create:{code,name,specimenType,unit,referenceRange,price}});

  const medications = [
    ['PARA500','Paracetamol','Acetaminophen','500 mg','Tablet',500,50],
    ['AMOX500','Amoxicillin','Amoxicillin','500 mg','Capsule',250,20],
    ['CET10','Cetirizine','Cetirizine','10 mg','Tablet',180,20],
    ['HYD1','Hydrocortisone','Hydrocortisone','1%','Cream',75,10]
  ];
  for (const [code,name,genericName,strength,form,stockQty,reorderAt] of medications) await prisma.medication.upsert({where:{code},update:{name,genericName,strength,form,stockQty,reorderAt,active:true},create:{code,name,genericName,strength,form,stockQty,reorderAt}});

  const ward = await prisma.ward.upsert({where:{code:'WARD-MAIN'},update:{name:'Main Inpatient Ward',departmentId:wardDept.id,active:true},create:{code:'WARD-MAIN',name:'Main Inpatient Ward',departmentId:wardDept.id}});
  for (let i=1;i<=20;i++) await prisma.bed.upsert({where:{wardId_bedNumber:{wardId:ward.id,bedNumber:`B-${String(i).padStart(2,'0')}`}},update:{status:'AVAILABLE'},create:{wardId:ward.id,bedNumber:`B-${String(i).padStart(2,'0')}`}});

  const bloodUnits = [
    ['BU-000001','Tesfaye Abebe','+251911100001','O+','WHOLE_BLOOD',450,'2026-10-06T08:00:00.000Z','2026-11-17T08:00:00.000Z','AVAILABLE'],
    ['BU-000002','Sara Bekele','+251911100002','A+','PACKED_RBC',300,'2026-10-05T09:00:00.000Z','2026-11-16T09:00:00.000Z','AVAILABLE'],
    ['BU-000003','Dawit Girma','+251911100003','B+','PLASMA',250,'2026-10-04T10:00:00.000Z','2027-04-04T10:00:00.000Z','QUARANTINED']
  ];
  for (const [unitNumber,donorName,donorPhone,bloodGroup,component,volumeMl,collectedAt,expiresAt,status] of bloodUnits) await prisma.bloodUnit.upsert({where:{unitNumber},update:{donorName,donorPhone,bloodGroup,component,volumeMl,collectedAt:new Date(collectedAt),expiresAt:new Date(expiresAt),status},create:{unitNumber,donorName,donorPhone,bloodGroup,component,volumeMl,collectedAt:new Date(collectedAt),expiresAt:new Date(expiresAt),status}});

  const services = [
    ['CONSULT','General Consultation',150, 'OPD'],
    ['ER-CONSULT','Emergency Consultation',300, 'ER'],
    ['CBC','Complete Blood Count',150, 'LAB'],
    ['XRAY','X-Ray Examination',350, 'RAD'],
    ['ULTRASOUND','Ultrasound Examination',500, 'RAD']
  ];
  for (const [code,name,price,deptCode] of services) { const department=await prisma.department.findUnique({where:{code:deptCode}}); await prisma.service.upsert({where:{code},update:{name,price,departmentId:department?.id,active:true},create:{code,name,price,departmentId:department?.id}}); }

  if (process.env.SEED_DEMO_DATA === 'true') {
    const existing = await prisma.patient.count();
    if (!existing) {
      const derm = await prisma.department.findUniqueOrThrow({where:{code:'DERM'}});
      await prisma.patient.createMany({data:[
        {patientNumber:'P-000001',firstName:'Abebe',lastName:'Tesfaye',phone:'+251911000001',departmentId:derm.id,sex:'MALE'},
        {patientNumber:'P-000002',firstName:'Sara',lastName:'Bekele',phone:'+251911000002',departmentId:derm.id,sex:'FEMALE'},
        {patientNumber:'P-000003',firstName:'Dawit',lastName:'Girma',phone:'+251911000003',departmentId:lab.id,sex:'MALE'},
        {patientNumber:'P-000004',firstName:'Mekdes',lastName:'Ali',phone:'+251911000004',departmentId:pharmacy.id,sex:'FEMALE'}
      ]});
    }
  }
  console.log('EasyNet HIS seed complete.');
}

main().catch(e=>{console.error(e);process.exit(1)}).finally(()=>prisma.$disconnect());
