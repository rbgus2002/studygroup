package ssu.groupstudy.global.handler;

import lombok.extern.slf4j.Slf4j;
import org.jetbrains.annotations.NotNull;
import org.springframework.context.support.DefaultMessageSourceResolvable;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import ssu.groupstudy.global.constant.ResultCode;
import ssu.groupstudy.global.dto.ErrorResponseDto;
import ssu.groupstudy.global.exception.BusinessException;

import javax.validation.UnexpectedTypeException;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponseDto> handleHttpMessageNotReadableException(HttpMessageNotReadableException e) {
        log.error("handleHttpMessageNotReadableException : {}", e.getMessage());
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.INVALID_JSON);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponseDto> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        log.error("handleMethodArgumentNotValidException : {}", e.getMessage());
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.INVALID_METHOD_ARGUMENT, getDefaultMessage(e));
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @NotNull
    private String getDefaultMessage(MethodArgumentNotValidException e) {
        return e.getBindingResult().getAllErrors().stream()
                .map(DefaultMessageSourceResolvable::getDefaultMessage)
                .findFirst()
                .orElse(ResultCode.INVALID_METHOD_ARGUMENT.getMessage());
    }

    @ExceptionHandler(UnexpectedTypeException.class)
    public ResponseEntity<ErrorResponseDto> handleUnexpectedTypeException(UnexpectedTypeException e) {
        log.error("handleUnexpectedTypeException : {}", e.getMessage());
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.INVALID_METHOD_ARGUMENT);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ErrorResponseDto> handleDataIntegrityViolationException(DataIntegrityViolationException e) {
        log.error("handleDataIntegrityViolationException : {}", e.getMessage());
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.NOT_SATISFIED_DB_CONSTRAINT);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    protected ResponseEntity<ErrorResponseDto> handleHttpRequestMethodNotSupportedException(HttpRequestMethodNotSupportedException e) {
        log.error("handleHttpRequestMethodNotSupportedException : {}", e.getMessage());
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.METHOD_NOT_ALLOWED);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(UnsupportedOperationException.class)
    protected ResponseEntity<ErrorResponseDto> handleUnsupportedOperationException(UnsupportedOperationException e) {
        log.error("UnsupportedOperationException : {}", e.getMessage());
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.METHOD_NOT_ALLOWED);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    protected ResponseEntity<ErrorResponseDto> handleIllegalArgumentException(IllegalArgumentException e) {
        log.error("IllegalArgumentException : {}", e.getMessage());
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.INVALID_METHOD_ARGUMENT);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(IllegalStateException.class)
    protected ResponseEntity<ErrorResponseDto> handleIllegalStateException(IllegalStateException e) {
        log.error("IllegalStateException : {}", e.getMessage());
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.INVALID_METHOD_ARGUMENT, e.getMessage());
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }


    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ErrorResponseDto> handleBusinessException(BusinessException e) {
        log.warn("BusinessException : {}", e.getMessage());
        final ErrorResponseDto response = ErrorResponseDto.of(e.getResultCode());
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }

    @ExceptionHandler(Exception.class)
    protected ResponseEntity<ErrorResponseDto> handleException(Exception e) {
        log.error("handleException : {}", e.getStackTrace());
        log.debug("handleException : {}", e.getCause());
        final ErrorResponseDto response = ErrorResponseDto.of(ResultCode.INTERNAL_SERVER_ERROR);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatusCode()));
    }
}
