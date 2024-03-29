package ssu.groupstudy.domain.feedback.service;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ssu.groupstudy.domain.feedback.domain.Feedback;
import ssu.groupstudy.domain.feedback.domain.FeedbackType;
import ssu.groupstudy.domain.feedback.dto.CreateNotionPageDto;
import ssu.groupstudy.domain.feedback.dto.SendFeedbackRequest;
import ssu.groupstudy.domain.feedback.repsoitory.FeedbackRepository;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.global.openfeign.NotionOpenFeign;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserFeedbackService {
    private final FeedbackRepository feedbackRepository;
    private final NotionOpenFeign notionOpenFeign;

    @Transactional
    public Long sendFeedback(FeedbackType type, SendFeedbackRequest request, User writer) {
        Feedback feedback = Feedback.create(type, request.getTitle(), request.getContents(), writer);
        saveToNotion(feedback);
        return feedbackRepository.save(feedback).getId();
    }

    private void saveToNotion(Feedback feedback) {
        CreateNotionPageDto dto = CreateNotionPageDto.create(feedback.getTitle(), feedback.getContents(), feedback.getWriter().getUserId(), feedback.getFeedbackType());
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String body = gson.toJson(dto);
        notionOpenFeign.createPage(body);
    }
}
