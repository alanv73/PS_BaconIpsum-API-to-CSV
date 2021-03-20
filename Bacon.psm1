class Bacon {
    [int]$id
    [string]$sentence
    [string]$paragraph

    Bacon(
        [int]$id,
        [string]$sentence,
        [string]$paragraph
    ) {
        $this.id = $id
        $this.sentence = $sentence
        $this.paragraph = $paragraph
    }

    [string]toJSONString() {
        $output = @"
{
    `"id`": $($this.id),
    `"sentence`": `"$($this.sentence)`",
    `"paragraph`": `"$($this.paragraph -replace "`n", " ")`"
}
"@

        return $output
    }

    static [Bacon]fromJSON($JsonData) {
        return New-Object Bacon(
            $JsonData.id,
            $JsonData.sentence,
            $JsonData.paragraph
        )
    }
}