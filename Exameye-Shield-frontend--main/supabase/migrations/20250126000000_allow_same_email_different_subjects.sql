-- SAFE migration: Allow same email + roll_no for different subjects
-- This preserves ALL existing data

-- Step 1: Check existing data count
DO $$
BEGIN
  RAISE NOTICE 'Current student records: %', (SELECT COUNT(*) FROM public.students);
END $$;

-- Step 2: Safely drop constraints (data is preserved)
ALTER TABLE public.students DROP CONSTRAINT IF EXISTS students_email_key;
ALTER TABLE public.students DROP CONSTRAINT IF EXISTS students_email_subject_code_key;
DROP INDEX IF EXISTS idx_students_roll_no_subject;

-- Step 3: Create new composite unique constraint
-- This allows same email+roll_no for different subjects
CREATE UNIQUE INDEX IF NOT EXISTS idx_students_email_rollno_subject 
ON public.students(email, roll_no, subject_code);

-- Step 4: Create performance indexes
CREATE INDEX IF NOT EXISTS idx_students_email ON public.students(email);
CREATE INDEX IF NOT EXISTS idx_students_roll_no ON public.students(roll_no);
CREATE INDEX IF NOT EXISTS idx_students_subject_code ON public.students(subject_code);

-- Step 5: Verify data is preserved
DO $$
BEGIN
  RAISE NOTICE 'Student records after migration: %', (SELECT COUNT(*) FROM public.students);
  RAISE NOTICE '✅ Migration completed - ALL DATA PRESERVED';
  RAISE NOTICE 'Same email + roll_no can now be used for different subjects';
END $$;