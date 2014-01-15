module Version
  # [Steve, 20080414]
  # ** DO NOT CHANGE THE FOLLOWING UNLESS YOU KNOW WHAT YOU'RE DOING!! **
  MAJOR   = '3.04'
  MINOR   = '05'
  BUILD   = '20140115'

  # Internal constant used to discriminate between all the existing and
  # running versions of the AgeX framework.
  FULL    = "#{MAJOR}.#{MINOR}.#{BUILD}"

  # Compact version of the versioning costant.
  COMPACT = "#{MAJOR.gsub('.','')}#{MINOR}"

  # Current internal DB version (indipendent from migrations and framework release)
#  DB      = "3.04.05"
end
