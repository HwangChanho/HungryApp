package com.server.assistant.repository

import com.server.assistant.entity.User
import org.springframework.data.repository.CrudRepository

/**
 * UserRepository
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-10-31
 */
interface UserRepository: CrudRepository<User, Long> {
    fun findUserById(id: Long): User
    fun findAllBy(): List<User>
    fun findUserByEmail(email: String): User?
    fun findUserByEmailAndPassword(email: String, password: String): User?
}