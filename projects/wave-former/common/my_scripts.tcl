
proc my_group_bd_cell {bd_group blocks} {
    if {$blocks != {}} {
        set bd_cell_blocks {}
        foreach block $blocks {
            lappend bd_cell_blocks [get_bd_cells $block]
        }
        group_bd_cells $bd_group $bd_cell_blocks
    }
}
