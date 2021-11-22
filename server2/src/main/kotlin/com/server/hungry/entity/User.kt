package com.server.assistant.entity

import com.server.assistant.dto.CreateUserDTO
import com.server.assistant.dto.ReadUserDTO
import org.hibernate.Hibernate
import java.time.OffsetDateTime
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id

/**
 * User
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-10-31
 */

@Entity
data class User(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,
    val name: String,
    val email: String,
    val password: String,
    val createdDate: OffsetDateTime,
    var updatedDate: OffsetDateTime? = null
) {
    fun toReadUserDto(): ReadUserDTO {
        return ReadUserDTO(
            id = id,
            name = name,
            email = email,
            createdDate = createdDate,
            updatedDate = updatedDate
        )
    }

    fun toCreateUserDto(): CreateUserDTO {
        return CreateUserDTO(
            name = name,
            email = email,
            password = password,
        )
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other == null || Hibernate.getClass(this) != Hibernate.getClass(other)) return false
        other as User

        return id != null && id == other.id
    }

    override fun hashCode(): Int = javaClass.hashCode()

    @Override
    override fun toString(): String {
        return this::class.simpleName + "(id = $id )"
    }
}
