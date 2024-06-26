package ssu.groupstudy.api.comment.vo;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.domain.comment.entity.CommentEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class ChildCommentInfoResVo {
    private Long userId;
    private String nickname;
    private String picture;

    private Long commentId;
    private String contents;
    private LocalDateTime createDate;
    private boolean deleteYn;

    private ChildCommentInfoResVo(CommentEntity comment) {
        UserEntity writer = comment.getWriter();
        this.userId = writer.getUserId();
        this.nickname = writer.getNickname();
        this.picture = writer.getPicture();

        this.commentId = comment.getCommentId();
        this.contents = comment.getContents();
        this.createDate = comment.getCreateDate();
        this.deleteYn = comment.isDeleteYn();
        processDeletedComment(comment);
    }

    private void processDeletedComment(CommentEntity comment) {
        if(comment.isDeleted()){
            this.nickname = "(삭제)";
            this.contents = "삭제된 댓글입니다.";
            this.picture = "";
        }
    }

    public static ChildCommentInfoResVo from(CommentEntity comment) {
        return new ChildCommentInfoResVo(comment);
    }
}
