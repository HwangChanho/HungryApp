package com.server.hungry.controller

import com.server.hungry.dto.LoginUserDTO
import io.swagger.annotations.*
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController


/**
 * TestController
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-11-20
 */
@RestController
class TestController {

    @GetMapping("/hello")
    @ApiOperation(value = "hello, world api", notes = "hello world swagger check")
    fun helloWorld(): String {
        return "hello, World"
    }

    @ApiOperation(value = "test", notes = "테스트입니다")
//    @ApiResponses(value = {
//        @ApiResponse(code = 200, message = "ok", response = LoginUserDTO.class),
//        @ApiResponse(code = 404, message = "page not found!", response = LoginUserDTO.class)
//    })
    @GetMapping("/board")
    fun selectBoard(
        @ApiParam(
            value = "샘플번호",
            required = true,
            example = "1"
        ) @RequestParam no: String?
    ): MutableMap<String, String> {
        val result: MutableMap<String, String> = HashMap()
        result["test title"] = "테스트"
        result["test contents"] = "테스트 내용"
        return result
    }

}