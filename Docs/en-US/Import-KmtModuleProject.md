---
external help file: KMT.ModuleBuilder-help.xml
Module Name: KMT.ModuleBuilder
online version:
schema: 2.0.0
---

# Import-KmtModuleProject

## SYNOPSIS
Imports the current module project if it is built

## SYNTAX

```
Import-KmtModuleProject [[-Path] <String[]>] [-DevelopmentVersion] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Import-KmtModuleProject
```

## PARAMETERS

### -DevelopmentVersion
{{ Fill DevelopmentVersion Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{ Fill Path Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 1
Default value: (Get-Location)
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Must run the build first

## RELATED LINKS
