package com.server.assistant.dto

import com.server.assistant.entity.User
import java.time.OffsetDateTime

/**
 * UserDTO
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-10-31
 */
data class LoginUserDTO(
    val email: String,
    val password: String
)

data class ReadUserDTO(
    val id: Long? = null,
    val name: String,
    val email: String,
    val createdDate: OffsetDateTime,
    val updatedDate: OffsetDateTime?
)

data class CreateUserDTO(
    val name: String,
    val email: String,
    val password: String,
) {
    fun toEntity(): User {
        return User(
            name = name,
            email = email,
            password = password,
            createdDate = OffsetDateTime.now()
        )
    }
}
