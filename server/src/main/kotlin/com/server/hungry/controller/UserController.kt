package com.server.hungry.controller

import com.server.hungry.dto.CreateUserDTO
import com.server.hungry.dto.LoginUserDTO
import com.server.hungry.service.UserService
import org.intellij.lang.annotations.RegExp
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

/**
 * UserController
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-11-20
 */
@RestController
@RequestMapping("/user")
class UserController {

    @Autowired
    private lateinit var userService: UserService

    @GetMapping("/", produces = ["application/json"])
    fun getUsers(): ResponseEntity<Any> {
        return ResponseEntity.ok().body(userService.getUsers())
    }

    @GetMapping("/{id}", produces = ["application/json"])
    fun getUser(@PathVariable id: Long): ResponseEntity<Any> {
        return ResponseEntity.ok().body(userService.getUser(id))
    }

    @PostMapping("/")
    fun createUser(@RequestBody createUserDTO: CreateUserDTO): ResponseEntity<Any> {
        return ResponseEntity.ok().body(userService.createUser(createUserDTO))
    }

    @PostMapping("/login", produces = ["application/json"])
    fun login(@RequestBody loginUserDTO: LoginUserDTO): ResponseEntity<Any> {
        return ResponseEntity.ok().body(userService.login(loginUserDTO))
    }
}