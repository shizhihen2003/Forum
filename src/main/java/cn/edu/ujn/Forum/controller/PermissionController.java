package cn.edu.ujn.Forum.controller;

import cn.edu.ujn.Forum.dao.Permission;
import cn.edu.ujn.Forum.dao.SearchRecord;
import cn.edu.ujn.Forum.dao.User;
import cn.edu.ujn.Forum.service.IPermissionService;
import cn.edu.ujn.Forum.service.ISearchRecordService;
import cn.edu.ujn.Forum.service.IUserService;
import cn.edu.ujn.Forum.util.Page;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;


@Controller
public class PermissionController {
    @Autowired
    private ISearchRecordService searchRecordService;

    @Autowired
    private IPermissionService permissionService;
    @Autowired
    private IUserService userService;

    @GetMapping("/p")
    public String list(@RequestParam(value = "page", defaultValue = "1") Integer page,
                       @RequestParam(value = "row", defaultValue = "10") Integer rows,
                       Model model, HttpSession session, Permission permission2, User user) {

        // try {
        List<User> users = userService.select();
        List<Permission> permissions = permissionService.selectAll1();

        // 遍历users列表
        for (int i = 0; i < users.size(); i++) {
            User user1 = users.get(i);
            String userPhone = user1.getPhone();

            if (userPhone != null) {
                Permission permission = null;

                // 检查是否有对应的permission
                if (i < permissions.size()) {
                    permission = permissions.get(i);
                }

                // 如果permission为null，创建一个新的Permission对象
                if (permission == null) {
                    permission = new Permission();
                }

                // 设置permission的userId
                permission.setUserId(userPhone);

                // 检查并设置targetPermission
                if ("111".equals(userPhone)) {
                    permission.setTargetPermission(1);
                } else {
                    Integer targetPermission = permission.getTargetPermission();
                    if (targetPermission == null || targetPermission != 1 && targetPermission != 2) {
                        permission.setTargetPermission(3);
                    }
                }

                // 插入或更新permission
                if (permission.getPermissionId() == null) {
                    permissionService.insert(permission);
                } else {
                    permissionService.updateByPrimaryKey(permission);
                }
            }
        }

        // 分页查询permission和user
        permission2.setStart((page - 1) * rows);
        permission2.setRows(rows);
        Page<Permission> page1 = permissionService.selectAll(permission2);
        page1.setPage(page);
        model.addAttribute("page", page1);

        user.setStart((page - 1) * rows);
        user.setRows(rows);
        Page<User> page2 = userService.selectAll(user);
        page2.setPage(page);
        model.addAttribute("page1", page2);

        // 获取登录用户信息
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            // 如果没有登录用户，重定向到登录页面
            return "redirect:/login";
        }

        String userId = loggedInUser.getPhone();

        // 设置用户权限
        if ("111".equals(userId)) {
            int target = 1;
            session.setAttribute("userPermission", target);
        } else {
            int target = permissionService.selecttarget(userId);
            session.setAttribute("userPermission", target);
        }

        return "permission";
    }
    /*} catch (Exception e) {
            // 捕获到异常，记录日志（可选）
            // logger.error("An error occurred in PermissionController#list: ", e);

            // 重定向到登录页面
            return "redirect:/login";
        }
    } */



    @PostMapping("permission/per")
    @ResponseBody
    public String createUser( HttpSession session,String username,
                              String email,
                              String phone,
                              String passwordHash,
                              int targetPermission)

    {
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        String userId = loggedInUser.getPhone();


        Permission permission = new Permission();

        permission.setTargetPermission(targetPermission);
        permission.setUserId(phone);

        // 调用服务层来创建用户
        permissionService.insert(permission);


        userService.insert1( username, email, phone,  passwordHash);



        return "OK";
    }


    @GetMapping("/permission/query/{userCode}")
    @ResponseBody
    public List<Permission> query(@PathVariable String userCode) {
        List<Permission> allPermissions = permissionService.getAllPermission().stream().filter(v -> v.getUserId().equals(userCode)).collect(Collectors.toList());
        if ("-1".equals(userCode)){
            return permissionService.getAllPermission();
        }
        for (Permission p : allPermissions) {
            p.getUserId().equals(userCode);
        }


        allPermissions.stream()
                .map(permission -> {
                    long currentTimeMillis = System.currentTimeMillis(); // 获取当前时间的毫秒级时间戳
                    // 假设SearchRecord的构造函数是：SearchRecord(String userId, int someTimeValue, String permissionId)
                    // 这里我们需要将long类型的时间戳转换为int类型，但请注意这样做可能会导致数据丢失（因为long比int范围大）
                    // 如果确定时间戳的值在int范围内，可以强制类型转换
                    int currentTimeInt = (int) currentTimeMillis; // 强制类型转换，可能会导致数据丢失
                    return new SearchRecord(permission.getUserId(), currentTimeInt, permission.getPermissionId());
                })
                .forEach(searchRecordService::insert);





        return allPermissions;
    }


    // 通过id获取用户信息（用于编辑）
    @GetMapping("/permission/{id}")
    @ResponseBody
    public void getUserById(@PathVariable String id,HttpSession session) {
        // 调用服务层来获取用户信息
        session.setAttribute("pm", id);


    }

    // 更新用户信息
    @PutMapping("/permission/update")
    @ResponseBody
    public String updateUser( @RequestBody Permission permission,HttpSession session) {
        // 调用服务层来更新用户信息
        String username=permission.getUser();
        String userId=permission.getUserId();
        int targetPermission=permission.getTargetPermission();

        String pm = (String) session.getAttribute("pm");
        User user = userService.selectByphone1(pm);
        System.out.println(pm);
        System.out.println(username);
        user.setUsername(username);
        user.setPassword(userId);
        userService.update(user);


        Permission permission1 = permissionService.updateByUserId(pm);

        permission1.setTargetPermission(targetPermission);
        permission1.setUserId(userId);

        permissionService.updateByPrimaryKey(permission1);
        return "OK";
    }
    // 删除用户
    @DeleteMapping("permission/delete/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable String id) {


        try {
            System.out.println(id);
            // 调用服务类的方法来删除用户
            permissionService.deleteByPrimaryKey(id);
            User user=  userService.selectByphone1(id);

            //  userService.deleteByPrimarye(9);
            System.out.println(user.toString());
            userService.delete(id);

            // 如果删除成功，返回"OK"作为响应体
            return ResponseEntity.ok("OK");
        } catch (Exception e) {
            // 如果删除失败，返回错误消息和HTTP状态码
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("删除用户时出错");
        }
    }
}
