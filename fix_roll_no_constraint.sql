-- SAFE migration: Remove unique constraint on roll_no (preserves all existing data)
-- This only removes the restriction, existing data remains intact

-- Step 1: Check existing data before changes
DO $$
BEGIN
  RAISE NOTICE 'Current student count: %', (SELECT COUNT(*) FROM public.students);
END $$;

-- Step 2: Drop unique constraint (data is preserved)
DROP INDEX IF EXISTS idx_students_roll_no;

-- Step 3: Create non-unique index for performance
CREATE INDEX IF NOT EXISTS idx_students_roll_no_lookup ON public.students(roll_no);

-- Step 4: Create composite unique constraint (roll_no + subject_code)
CREATE UNIQUE INDEX IF NOT EXISTS idx_students_roll_no_subject ON public.students(roll_no, subject_code);

-- Step 5: Verify data is still there
DO $$
BEGIN
  RAISE NOTICE 'Student count after migration: %', (SELECT COUNT(*) FROM public.students);
  RAISE NOTICE 'Migration completed successfully - all data preserved';
END $$;