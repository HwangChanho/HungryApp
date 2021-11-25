package com.server.hungry.dto

import com.server.hungry.entity.Photo
import com.server.hungry.entity.Store
import com.server.hungry.entity.User
import java.time.OffsetDateTime

/**
 * UserDTO
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-11-20
 */
data class LoginUserDTO(
    val email: String,
    val password: String
)

data class ReadUserDTO(
    val id: Long?,
    val name: String,
    val email: String,
    val createdDate: OffsetDateTime,
    val updatedDate: OffsetDateTime?,
    val photo: Photo,
)

data class CreateUserDTO(
    val name: String,
    val email: String,
    val password: String,
    val photo: Photo,
) {
    fun toEntity(): User {
        return User(
            name = name,
            email = email,
            password = password,
            createdDate = OffsetDateTime.now(),
            photo = photo,
        )
    }
}
