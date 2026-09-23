# ฐานข้อมูล Supabase

แอป (`app.html`) บันทึก/โหลด/แก้ไข/ลบผลการประเมินผ่าน Supabase แทน Google Sheet (Apps Script) เดิม

- โปรเจกต์: `smartwean-navigator` (region ap-southeast-1) — `https://jxpcnzajacpkzervuvec.supabase.co`
- ตาราง: `public.assessments` — สคีมาอยู่ใน [`schema.sql`](schema.sql)
  - `save_id` (PK), `hn`, `ward`, `adate` สำหรับค้นหา
  - `data` (jsonb) เก็บทุกฟิลด์จาก `buildSheetPayload()` แบบเดิม
  - `created_at`, `updated_at`
- การตั้งค่าฝั่งเว็บอยู่ที่ต้นสคริปต์ใน `app.html` (`SUPABASE_URL`, `SUPABASE_ANON_KEY` = publishable key)

## ความปลอดภัย

แอปยังไม่มีระบบล็อกอิน RLS จึงเปิดให้ role `anon` อ่าน/เขียน/ลบได้ทั้งหมด
(ระดับเดียวกับรหัสลับ Apps Script เดิมที่อยู่ในหน้าเว็บ) ผู้ที่มี URL + publishable key
เข้าถึงข้อมูลผู้ป่วยได้ — ควรเพิ่ม Supabase Auth แล้วจำกัด policy ให้เฉพาะผู้ใช้ที่ล็อกอินก่อนใช้งานจริง

## ย้ายข้อมูลเก่าจาก Google Sheet

Export ชีตเป็น CSV/JSON แล้ว insert เข้า `assessments` โดยใส่ทั้งแถวลงใน `data`
และคัดลอก `save_id`, `hn`, `ward`, `adate` ไปยังคอลัมน์ของตัวเอง
