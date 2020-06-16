{-# LANGUAGE TypeFamilies #-}
module Software.Organization.Core.Types where

import Data.Word

-- | Uniquely identifies a given project
newtype ProjectID = ProjectID String

-- | A project is an ongoing body of work
data Project = Project
  { projectID :: ProjectID
    -- ^ identifies this project uniquely
  , name :: String
    -- ^ the name of this project
  , body :: [Task]
    -- ^ the tasks inside this project
  , dependencies :: [Dependency]
    -- ^ the dependencies inside this project
  }

-- | Represents some directional inter-work dependency within a project
data Dependency = Dependency
  { from :: TaskID
    -- ^ who the dependency comes from, i.e. who requires something or else is slowed
  , to :: TaskID
    -- ^ who the dependency is to, i.e. who needs to get something done to lessen this dependency
  , why :: DependencyType
    -- ^ why is this dependency present?
  }

data DependencyType =
    BlockedBy
    -- ^ For a task blocking another
  | Refines
    -- ^ For a task meant to refine another task, like a spike ticket,
    --   increasing its confidence level. This is meant to be done to low confidence tasks.
  | Eases
    -- ^ For a task which eases the work of another task
  | Obviates
    -- ^ For a task which obviates another task. Doing this task will count as
    --   you doing the other task.
  | Pains
    -- ^ For a task which makes another task more painful. Doing this task will
    --   automatically make another task rated harder.

-- | Uniquely identified a given (sub)task
newtype TaskID = TaskID String

-- | A unit of work inside of a project
data Task =
    Subtasks
      TaskID
      -- ^ identifies this task uniquely
      String
      -- ^ name of the task
      String
      -- ^ description of the task
      [Tag]
      -- ^ tags related to this task
      [(String, String, Task)]
      -- ^ other tasks with names, descriptions
  | IndividualTask
      TaskID
      -- ^ identifies this task uniquely
      String
      -- ^ name of the task
      String
      -- ^ description of the task
      [Tag]
      -- ^ tags related to this task

-- | Represents the probability that this task will get done as specified
newtype Confidence = Confidence { unConfidence :: Rational }

-- | You expect that this task will proceed exactly as written
high :: Confidence
high = Confidence 0.95

-- | You expect that, though there might be change, if your best
--   understanding as of now is correct, this task will proceed
--   more or less as written
baseline :: Confidence
baseline = Confidence 0.7

-- | You expect there to be some changes to this task before it
--   can or should be executed.
low :: Confidence
low = Confidence 0.2

-- | The various states a task can be in
data TaskStatus =
    Todo
    -- ^ A task yet to be started
  | InProgress
    -- ^ A task which has been started
  | InReview
    -- ^ A task which is being reviewed
  | Complete
    -- ^ A task which is complete
  | Canned
    -- ^ A task which will not be done

-- | A type meant to represent textual annotations to tasks
newtype Tag = Tag String
