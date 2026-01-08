package com.meomureum.springboot;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.meomureum.springboot.dao")
public class MeomureumApplication {

	public static void main(String[] args) {
		SpringApplication.run(MeomureumApplication.class, args);
	}

}
