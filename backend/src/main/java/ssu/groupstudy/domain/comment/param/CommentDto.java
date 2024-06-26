package ssu.groupstudy.domain.comment.param;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import ssu.groupstudy.api.comment.vo.ChildCommentInfoResVo;
import ssu.groupstudy.domain.comment.entity.CommentEntity;
import ssu.groupstudy.domain.user.entity.UserEntity;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CommentDto { // [2024-06-10:최규현] TODO: 얘 뭐야 param이야?
    private Long userId;
    private String nickname;
    private String picture;

    private Long commentId;
    private String contents;
    private LocalDateTime createDate;
    private boolean deleteYn;

    private List<ChildCommentInfoResVo> replies = null;

    private CommentDto(CommentEntity comment) {
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

    public static CommentDto from(CommentEntity comment) {
        return new CommentDto(comment);
    }

    public void appendReplies(List<ChildCommentInfoResVo> replies){
        this.replies = replies;
    }

    public boolean requireRemoved(){
        return this.isDeleted() && !this.existReplies();
    }

    private boolean isDeleted(){
        return this.deleteYn;
    }

    private boolean existReplies(){
        return this.replies != null && !isReplyEmpty();
    }

    private boolean isReplyEmpty(){
        return replies.stream()
                .noneMatch(reply -> !reply.isDeleteYn());
    }
}