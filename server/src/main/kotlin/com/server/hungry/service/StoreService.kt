package com.server.hungry.service

import com.server.hungry.dto.CreateStoreDTO
import com.server.hungry.repository.StoreRepository
import com.server.hungry.repository.UserRepository
import com.server.hungry.response.Response
import com.server.hungry.response.Result
import mu.KotlinLogging
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional

/**
 * StoreService
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-11-21
 */
private val logger = KotlinLogging.logger { }

@Component
class StoreService {

    @Autowired
    private lateinit var storeRepository: StoreRepository
    @Autowired
    private lateinit var userRepository: UserRepository

    @Transactional
    fun getStores(): Response {
        val stores = storeRepository.findAll()
        val response = Response(result = Result.SUCCESS.name, message = null, meta = {})
        response.setDataList(stores.map { it.toReadStoreDto() }.toMutableList())
        return response
    }

    @Transactional
    fun getStore(id: Long): Response {
        if (!storeRepository.existsById(id))
            return Response(result = Result.FAILURE.name, message = "존재하지 않는 가게 입니다.", meta = {})
        val store = storeRepository.findById(id).get()
        val response = Response(result = Result.SUCCESS.name, message = null, meta = {})
        response.addData(store.toReadStoreDto())
        return response
    }

    @Transactional
    fun createStore(createStoreDTO: CreateStoreDTO): Response {
        createStoreDTO.user.id ?: return Response(result = Result.FAILURE.name, message = "존재하지 않는 유저 입니다.", meta = {})
        createStoreDTO.user = userRepository.findById(createStoreDTO.user.id!!).get()
        val store = storeRepository.save(createStoreDTO.toEntity())
        val response = Response(result = Result.SUCCESS.name, message = null, meta = {})
        response.addData(store.toReadStoreDto())
        return response
    }

    @Transactional
    fun deleteStore(id: Long): Response {
        if (!storeRepository.existsById(id))
            return Response(result = Result.FAILURE.name, message = "존재하지 않는 가게 입니다.", meta = {})
        storeRepository.deleteById(id)
        return if (!storeRepository.existsById(id))
            Response(result = Result.SUCCESS.name, message = "삭제 완료.", meta = {})
        else
            Response(result = Result.FAILURE.name, message = "삭제 실패.", meta = {})
    }


}