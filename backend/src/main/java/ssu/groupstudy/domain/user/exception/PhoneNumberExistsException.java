package ssu.groupstudy.domain.user.exception;

import ssu.groupstudy.global.exception.BusinessException;
import ssu.groupstudy.global.constant.ResultCode;

public class PhoneNumberExistsException extends BusinessException {
    public PhoneNumberExistsException(ResultCode resultCode){
        super(resultCode);
    }
}
