package ssu.groupstudy.global.util;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.ObjectMetadata;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import ssu.groupstudy.domain.common.enums.S3TypeCode;

import java.io.IOException;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@Slf4j
public class S3Utils {
    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String imageBucket;

    public String uploadProfileImage(MultipartFile image, S3TypeCode code, Long id) throws IOException {
        if (image == null) {
            return null;
        }
        ObjectMetadata metadata = createMetadataForFile(image);
        String imageName = generateImageName(code, id);
        amazonS3.putObject(imageBucket, imageName, image.getInputStream(), metadata);
        return amazonS3.getUrl(imageBucket, imageName).toString();
    }

    private ObjectMetadata createMetadataForFile(MultipartFile file) {
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(file.getSize());
        metadata.setContentType(file.getContentType());
        return metadata;
    }

    private String generateImageName(S3TypeCode code, Long id) {
        return String.format(code.getFormat(), id, UUID.randomUUID());
    }
}
