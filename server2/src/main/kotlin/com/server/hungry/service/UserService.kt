package com.server.assistant.service

import com.server.assistant.dto.CreateUserDTO
import com.server.assistant.dto.LoginUserDTO
import com.server.assistant.entity.User
import com.server.assistant.repository.UserRepository
import com.server.assistant.response.Response
import com.server.assistant.response.Result
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import java.util.*

/**
 * UserService
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-10-31
 */

@Component
class UserService {
    @Autowired
    lateinit var userRepository: UserRepository

    fun getUsers(): Response {
        val users = userRepository.findAllBy()
        val response = Response(result = Result.SUCCESS.name, message = null, meta = {})
        response.setDataList(users.map { it.toReadUserDto() }.toMutableList())
        return response
    }

    fun getUser(id: Long): Response {
        val user = userRepository.findUserById(id)
        val response = Response(result = Result.SUCCESS.name, message = null, meta = {})
        response.addData(user)
        return response
    }

    @Transactional
    fun createUser(createUserDTO: CreateUserDTO): Response {
        val user = userRepository.save(createUserDTO.toEntity())
        val response = Response(result = Result.SUCCESS.name, message = null, meta = {})
        response.addData(user)
        return response
    }

    fun login(loginUserDTO: LoginUserDTO): Response {
        var user: User? = userRepository.findUserByEmail(loginUserDTO.email)
        user ?: return Response(result = Result.FAILURE.name, message = "존재하지 않는 아이디 입니다.", meta = {})
        user = userRepository.findUserByEmailAndPassword(loginUserDTO.email, loginUserDTO.password)
        user ?: return Response(result = Result.FAILURE.name, message = "비밀번호가 일치하지 않습니다.", meta = {})
        return Response(result = Result.SUCCESS.name, message = null, meta = {}, user)
    }
}