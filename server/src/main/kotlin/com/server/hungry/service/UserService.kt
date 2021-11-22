package com.server.hungry.service

import com.server.hungry.dto.CreateUserDTO
import com.server.hungry.dto.LoginUserDTO
import com.server.hungry.entity.User
import com.server.hungry.repository.UserRepository
import com.server.hungry.response.Response
import com.server.hungry.response.Result
import mu.KotlinLogging
import org.slf4j.Logger
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional

/**
 * UserService
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-11-20
 */
private val logger = KotlinLogging.logger {  }
@Component
class UserService {

    @Autowired
    private lateinit var userRepository: UserRepository

    @Transactional
    fun getUsers(): Response {
        val users = userRepository.findAllBy()
        val response = Response(result = Result.SUCCESS.name, message = null, meta = {})
        response.setDataList(users.map { it.toReadUserDto() }.toMutableList())
        return response
    }

    @Transactional
    fun getUser(id: Long): Response {
        val user: User? = userRepository.findUserById(id)
        user ?: return Response(result = Result.FAILURE.name, message = "존재하지 않는 유저 입니다.", meta = {})
        val response = Response(result = Result.SUCCESS.name, message = null, meta = {})
        response.addData(user.toReadUserDto())
        return response
    }

    @Transactional
    fun createUser(createUserDTO: CreateUserDTO): Response {
        val user = userRepository.save(createUserDTO.toEntity())
        val response = Response(result = Result.SUCCESS.name, message = null, meta = {})
        response.addData(user.toReadUserDto())
        return response
    }

    @Transactional
    fun login(loginUserDTO: LoginUserDTO): Response {
        var user: User? = userRepository.findUserByEmail(loginUserDTO.email)
        user ?: return Response(result = Result.FAILURE.name, message = "존재하지 않는 아이디 입니다.", meta = {})
        user = userRepository.findUserByEmailAndPassword(loginUserDTO.email, loginUserDTO.password)
        user ?: return Response(result = Result.FAILURE.name, message = "비밀번호가 일치하지 않습니다.", meta = {})
        return Response(result = Result.SUCCESS.name, message = null, meta = {}, user.toReadUserDto())
    }

    @Transactional
    fun deleteUser(id:Long): Response {
        if (!userRepository.existsById(id))
            return Response(result = Result.FAILURE.name, message = "존재하지 않는 유저 입니다.", meta = {})
        userRepository.deleteById(id)
        return if (!userRepository.existsById(id))
            Response(result = Result.SUCCESS.name, message = "삭제 완료.", meta = {})
        else
            Response(result = Result.FAILURE.name, message = "삭제 실패.", meta = {})
    }
}