package com.example.archcompsblueprint

import org.junit.Test

import org.junit.Assert.*

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
class ExampleUnitTest {
    @Test
    fun addition_isCorrect() {
        assertEquals(5, 3 + 2)
    }
    
    @Test
    fun addition_isCorrect5() {
        assertEquals(5, 3 + 2)
    }
    
    @Test
    fun addition_isCorrect6() {
        assertEquals(10, 8 + 2)
    }
    
    @Test
    fun addition_isNotCorrect() {
        assertEquals(4, 3 + 2)
    }
    
    @Test
    fun addition_isCorrect1() {
        assertEquals(6, 4 + 2)
    }
    
    @Test
    fun addition_isNotCorrect2() {
        assertEquals(6, 5 + 2)
    }
}
