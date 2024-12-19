package cn.edu.ujn.Forum.aspectj;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

import java.util.logging.Logger;

/**
 *
 * @author ujn
 * 创建时间：2024年3月14日
 *
 */
@Aspect
@Component
public class LogAspect {

	public static Logger log = Logger.getLogger(LogAspect.class.toString());
	@Pointcut("execution(* cn.edu.ujn.Forum.service.*.*(..))")
	public void myPointCut(){}
	@Before("myPointCut()")
	public void myBefore(JoinPoint joinPoint){
		log.info("前置通知："+joinPoint.getTarget().toString()+"-----"+joinPoint.getSignature().getName());
	}
	@Around("myPointCut()")
	public Object myAround(ProceedingJoinPoint pjp) throws Throwable{
		log.info("【环绕前置通知】【"+ pjp.getSignature().getName()+"方法开始】");
		Object proceed = pjp.proceed();
		log.info("【环绕返回通知】【"+pjp.getSignature().getName()+"方法返回，返回值："+proceed+"】");
		return proceed;
	}

}
