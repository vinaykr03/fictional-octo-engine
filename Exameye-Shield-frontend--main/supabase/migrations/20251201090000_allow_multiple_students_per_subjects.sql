-- Allow multiple students to share the same subject code while keeping roll numbers unique
-- Drops the accidental UNIQUE constraint on students.subject_code and replaces it with a regular index

DO $$
BEGIN
  -- Drop the unique constraint if it exists
  IF EXISTS (
    SELECT 1
    FROM   information_schema.table_constraints
    WHERE  table_name = 'students'
    AND    constraint_name = 'students_subject_code_key'
  ) THEN
    ALTER TABLE public.students
      DROP CONSTRAINT students_subject_code_key;
  END IF;
EXCEPTION
  WHEN undefined_table THEN
    -- Table might not exist yet on fresh environments, ignore
    NULL;
END $$;

-- Ensure a non-unique index exists to keep lookups fast
CREATE INDEX IF NOT EXISTS idx_students_subject_code
  ON public.students(subject_code);

