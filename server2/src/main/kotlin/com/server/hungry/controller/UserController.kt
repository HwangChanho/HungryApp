package com.server.assistant.controller

import com.server.assistant.dto.CreateUserDTO
import com.server.assistant.dto.LoginUserDTO
import com.server.assistant.service.UserService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

/**
 * UserController
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-10-31
 */
@RestController
class UserController {

    @Autowired
    private lateinit var userService: UserService

    @GetMapping("/users", produces = ["application/json"])
    fun getUsers(): ResponseEntity<Any> {
        return ResponseEntity.ok().body(userService.getUsers())
    }

    @GetMapping("/user/{id}", produces = ["application/json"])
    fun getUser(@PathVariable id: Long): ResponseEntity<Any> {
        return ResponseEntity.ok().body(userService.getUser(id))
    }

    @PostMapping("/user")
    fun createUser(@RequestBody createUserDTO: CreateUserDTO): ResponseEntity<Any> {
        return ResponseEntity.ok().body(userService.createUser(createUserDTO))
    }

    @PostMapping("/login", produces = ["application/json"])
    fun login(@RequestBody loginUserDTO: LoginUserDTO): ResponseEntity<Any> {
        return ResponseEntity.ok().body(userService.login(loginUserDTO))
    }
}