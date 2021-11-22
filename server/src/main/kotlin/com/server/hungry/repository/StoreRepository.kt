package com.server.hungry.repository

import com.server.hungry.entity.Store
import org.springframework.data.repository.CrudRepository

/**
 * StoreRepository
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-11-21
 */
interface StoreRepository: CrudRepository<Store, Long> {
}