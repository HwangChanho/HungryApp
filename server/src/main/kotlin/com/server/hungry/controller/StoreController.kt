package com.server.hungry.controller

import com.server.hungry.dto.CreateStoreDTO
import com.server.hungry.service.StoreService
import mu.KotlinLogging
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

/**
 * StoreController
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-11-21
 */
private val logger = KotlinLogging.logger {  }
@RestController
class StoreController {

    @Autowired
    private lateinit var storeService: StoreService

    @GetMapping("/stores",produces = ["application/json"])
    fun getStores(): ResponseEntity<Any> {
        return ResponseEntity.ok().body(storeService.getStores())
    }

    @GetMapping("/store/{id}", produces = ["application/json"])
    fun getStore(@PathVariable id: Long): ResponseEntity<Any> {
        return ResponseEntity.ok().body(storeService.getStore(id))
    }

    @PostMapping("/store")
    fun createUser(@RequestBody createStoreDTO: CreateStoreDTO): ResponseEntity<Any> {
        return ResponseEntity.ok().body(storeService.createStore(createStoreDTO))
    }

    @DeleteMapping("/store/{id}")
    fun deleteStore(@PathVariable id:Long): ResponseEntity<Any> {
        return ResponseEntity.ok().body(storeService.deleteStore(id))
    }
}