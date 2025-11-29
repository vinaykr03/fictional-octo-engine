-- Allow same roll number for different subjects
-- Remove unique constraint on roll_no to allow students to take multiple subject exams

-- Drop the unique index on roll_no
DROP INDEX IF EXISTS idx_students_roll_no;

-- Create a non-unique index for performance
CREATE INDEX IF NOT EXISTS idx_students_roll_no_lookup ON public.students(roll_no);

-- Create composite unique constraint on roll_no + subject_code instead
-- This ensures same roll_no can exist for different subjects but not duplicate entries
CREATE UNIQUE INDEX IF NOT EXISTS idx_students_roll_no_subject 
ON public.students(roll_no, subject_code);

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Migration completed: Allow duplicate roll numbers for different subjects';
  RAISE NOTICE '📋 Changes:';
  RAISE NOTICE '  - Removed unique constraint on roll_no';
  RAISE NOTICE '  - Added composite unique constraint on (roll_no, subject_code)';
  RAISE NOTICE '  - Same roll number can now register for multiple subjects';
END $$;