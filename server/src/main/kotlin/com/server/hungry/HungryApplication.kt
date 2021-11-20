package com.server.hungry

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class HungryApplication

fun main(args: Array<String>) {
    runApplication<HungryApplication>(*args)
}
