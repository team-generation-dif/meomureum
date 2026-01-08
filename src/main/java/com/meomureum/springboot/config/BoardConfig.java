package com.meomureum.springboot.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class BoardConfig implements WebMvcConfigurer { // 인터페이스 구현 추가
	@Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 1. 브라우저에서 사용할 가상 경로 설정 (/upload/파일명.jpg 형식으로 접근)
        registry.addResourceHandler("/upload/**")
                // 2. 실제 파일이 저장된 물리적 경로 매핑 (끝에 /를 반드시 붙여주세요)
                .addResourceLocations("file:///C:/upload/");
    }

}
