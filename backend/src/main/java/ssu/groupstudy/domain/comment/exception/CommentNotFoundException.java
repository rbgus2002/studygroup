package ssu.groupstudy.domain.comment.exception;

import ssu.groupstudy.global.ResultCode;
import ssu.groupstudy.global.exception.BusinessException;

public class CommentNotFoundException extends BusinessException {
    public CommentNotFoundException(ResultCode resultCode) {
        super(resultCode);
    }
}
