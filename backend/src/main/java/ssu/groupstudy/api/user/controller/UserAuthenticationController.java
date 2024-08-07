package ssu.groupstudy.api.user.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.api.user.vo.MessageReqVo;
import ssu.groupstudy.api.user.vo.PasswordResetReqVo;
import ssu.groupstudy.api.user.vo.UserSignUpVerifyReqVo;
import ssu.groupstudy.domain.auth.param.JwtTokenParam;
import ssu.groupstudy.domain.auth.service.AuthService;
import ssu.groupstudy.api.user.vo.SignInReqVo;
import ssu.groupstudy.api.user.vo.SignUpReqVo;
import ssu.groupstudy.api.user.vo.SignInResVo;
import ssu.groupstudy.api.common.vo.DataResVo;
import ssu.groupstudy.api.common.vo.ResVo;

import javax.validation.Valid;
import java.io.IOException;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "Auth", description = "인증 API")
public class UserAuthenticationController {
    private final AuthService authService;

    @Operation(summary = "로그인", description = "로그인에 성공하면 JWT를 발급한다.")
    @PostMapping("/signIn")
    public ResVo signIn(@Valid @RequestBody SignInReqVo request) {
        JwtTokenParam jwtTokenParam = authService.signIn(request);
        return DataResVo.of("loginUser", SignInResVo.of(jwtTokenParam));
    }

    @Operation(summary = "회원가입")
    @PostMapping("/signUp")
    public ResVo signUp(@Valid @RequestPart("dto") SignUpReqVo dto, @RequestPart(value = "profileImage", required = false) MultipartFile profileImage) throws IOException {
        Long userId = authService.signUp(dto, profileImage);
        return DataResVo.of("userId", userId);
    }

    @Operation(summary = "회원가입 인증코드 문자 전송", description = "문자 메세지로 회원가입 인증코드를 전송한다. (발신번호 : 01044992038)")
    @PostMapping("/signUp/send")
    public ResVo sendMessageToSignUp(@Valid @RequestBody MessageReqVo request) {
        authService.sendMessageToSignUp(request);
        return DataResVo.success();
    }

    @Operation(summary = "인증코드 검증", description = "발급받은 인증번호가 올바른지 검사한다.")
    @PostMapping("/verify")
    public ResVo verifyCode(@Valid @RequestBody UserSignUpVerifyReqVo request) {
        boolean isSuccess = authService.verifyCode(request);
        return DataResVo.of("isSuccess", isSuccess);
    }

    @Operation(summary = "비밀번호 재설정", description = "비밀번호를 잊어버린 경우, 휴대전화로 비밀번호를 재설정한다.")
    @PutMapping("/passwords")
    public ResVo resetPassword(@Valid @RequestBody PasswordResetReqVo request) {
        authService.resetPassword(request);
        return DataResVo.success();
    }

    @Operation(summary = "비밀번호 재설정 인증코드 문자 전송", description = "문자 메세지로 비밀번호 재설정 인증코드를 전송한다. (발신번호 : 01044992038)")
    @PostMapping("/passwords/send")
    public ResVo sendMessageToResetPassword(@Valid @RequestBody MessageReqVo request) {
        authService.sendMessageToResetPassword(request);
        return DataResVo.success();
    }
}

