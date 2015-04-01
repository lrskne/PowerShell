﻿<#
  .Synopsis
   Take in lines and spit out unique lines
  .DESCRIPTION
   Long description
  .EXAMPLE
   Example of how to use this cmdlet
  .EXAMPLE
   Another example of how to use this cmdlet
  .INPUTS
   Inputs to this cmdlet (if any)
  .OUTPUTS
   Output from this cmdlet (if any)
  .NOTES
   General notes
  .COMPONENT
   The component this cmdlet belongs to
  .ROLE
   The role this cmdlet belongs to
  .FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Get-Unique
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(0,5)]
        [ValidateSet("sun", "moon", "earth")]
        [Alias("p1")] 
        $Param1,

        # Param2 help description
        [Parameter(ParameterSetName='Parameter Set 1')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [ValidateScript({$true})]
        [ValidateRange(0,5)]
        [int]
        $Param2,

        # Param3 help description
        [Parameter(ParameterSetName='Another Parameter Set')]
        [ValidatePattern("[a-z]*")]
        [ValidateLength(0,15)]
        [String]
        $Param3
      )
      $inputLeaf = 'mlo_tmp.txt'
      $outputLeaf = 'mlo_nodups.txt'
      $inputFileFullPath = (join-path -path "$HOME\Documents\MyLifeOrganized" -child $inputLeaf)

      $outputFileFullPath = (join-path -path "$HOME\Documents\MyLifeOrganized"  -child $outputLeaf )

  
     Get-Content $inputFileFullPath | select-object -unique | out-file $outputFileFullPath
      
    }

#testing area

'start hello'

Get-Unique


<#
    Begin
    {
    }
    Process
    {
    
        if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
        }
    
  
  }
    End
    {
    }#>