-- Drop old constraint
ALTER TABLE public.students DROP CONSTRAINT IF EXISTS students_email_subject_code_key;

-- Add new constraint: prevent duplicate (roll_no + subject_code) but allow same email
CREATE UNIQUE INDEX IF NOT EXISTS idx_students_rollno_subject_unique 
ON public.students(roll_no, subject_code);