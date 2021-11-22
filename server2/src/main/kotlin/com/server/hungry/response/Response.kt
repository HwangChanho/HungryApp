package com.server.assistant.response

/**
 * Response
 * 주소
 * GitHub : http://github.com/azqazq195
 * Created by azqazq195@gmail.com on 2021-11-03
 */
enum class Result{
    SUCCESS, FAILURE
}

data class Response (
    val result: String,
    val message: String?,
    val meta: Any,
    val data: MutableList<Any> = mutableListOf()
) {
    constructor(result: String, message: String?, meta: Any, data: Any): this(
        result, message, meta
    ) {
        this.data.add(data)
    }

    fun addData(data: Any) {
        this.data.add(data)
    }

    fun addDataList(dataList: MutableList<Any>) {
        this.data.addAll(dataList)
    }

    fun setDataList(dataList: MutableList<Any>) {
        this.data.clear()
        this.data.addAll(dataList)
    }
}