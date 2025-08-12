# HR-Database-Schema
Oracle 11g Database Schema for HR &amp; Finance System
دليل تنفيذ قاعدة البيانات - نظام الموارد البشرية والمالية

الخطوة 1: الاتصال بقاعدة بيانات Oracle 11g
- استخدم أداة مثل:
  • Oracle SQL Developer
  • SQL*Plus
  • TOAD

الخطوة 2: تنفيذ ملف schema
- افتح ملف database_schema.sql في الأداة.
- نفّذ جميع الأوامر (Run as Script).

ملاحظات:
- تأكد من أن المستخدم لديه صلاحيات CREATE TABLE, CREATE SEQUENCE.
- يمكن تنفيذ الملف دفعة واحدة أو جزءاً جزءاً.

الخطوة 3: إدخال بيانات تجريبية (اختياري)
- نفّذ ملف sample_data_inserts.sql بعد إنشاء الجداول.

الخطوة 4: التحقق
- استخدم SELECT * FROM table_name; للتحقق من الجداول.

تم إعداد النظام بنجاح!
