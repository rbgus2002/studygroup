package ssu.groupstudy.domain.user.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.user.domain.User;
import ssu.groupstudy.domain.user.dto.request.StatusMessageRequest;
import ssu.groupstudy.domain.user.repository.UserRepository;
import ssu.groupstudy.global.util.S3Utils;

import java.io.IOException;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {
    private final UserRepository userRepository;
    private final S3Utils s3Utils;

    @Transactional
    public void updateStatusMessage(User user, StatusMessageRequest request) {
        user.setStatusMessage(request.getStatusMessage());
        userRepository.save(user);
    }

    @Transactional
    public String updateProfileImage(User user, MultipartFile image) throws IOException {
        String imageUrl = s3Utils.uploadUserProfileImage(image, user);
        user.updatePicture(imageUrl);
        return imageUrl;
    }
}
