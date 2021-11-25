package com.server.hungry.dto

import com.server.hungry.entity.Photo
import com.server.hungry.entity.Store
import com.server.hungry.entity.User

/**
 * StoreDTO
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-11-21
 */
data class ReadStoreDTO(
    val id: Long? = null,
    val name: String,
    val description: String?,
    val rating: Double,
//    val photo: MutableList<Photo>,
    val user: ReadUserDTO
)

data class CreateStoreDTO(
    val id: Long? = null,
    val name: String,
    val description: String?,
    val rating: Double,
//    val photo: MutableList<Photo>,
    var user: User
) {
    fun toEntity(): Store {
        return Store(
            id = id,
            name = name,
            description = description,
            rating = rating,
//            photo = photo,
            user = user
        )
    }
}