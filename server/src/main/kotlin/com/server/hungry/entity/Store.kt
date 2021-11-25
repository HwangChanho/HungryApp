package com.server.hungry.entity

import com.server.hungry.dto.ReadStoreDTO
import org.hibernate.Hibernate
import javax.persistence.*

/**
 * Store
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-11-21
 */
@Entity
data class Store(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,
    val name: String,
    val description: String?,
    val rating: Double,

//    @OneToMany(cascade = [CascadeType.ALL])
//    val photo: MutableList<Photo> = mutableListOf(),

    @ManyToOne
    val user: User
) {
    fun toReadStoreDto(): ReadStoreDTO {
        return ReadStoreDTO(
            id = id,
            name = name,
            description = description,
            rating = rating,
//            photo = photo,
            user = user.toReadUserDto()
        )
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other == null || Hibernate.getClass(this) != Hibernate.getClass(other)) return false
        other as Store

        return id != null && id == other.id
    }

    override fun hashCode(): Int = javaClass.hashCode()

    @Override
    override fun toString(): String {
        return this::class.simpleName + "(id = $id , name = $name , description = $description , rating = $rating )"
    }
}