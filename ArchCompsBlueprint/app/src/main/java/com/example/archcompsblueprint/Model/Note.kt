package com.example.archcompsblueprint.Model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "note_table")
data class Note (
    @PrimaryKey(autoGenerate = true)
    private val id: Int,
    private val title: String,
    private val description: String,
    private val priority: Int
)