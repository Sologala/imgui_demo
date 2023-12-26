#include "imgui.h"
#include "imgui_impl_glfw_gl3.h"
#include <stdio.h>
#include <GL/gl3w.h> //  使用gl3w，glad也行，注意要在项目工程中添加gl3w.c（或者glad.c/使用glad）
#include <GLFW/glfw3.h>
#include <iostream>
#include <common/shader.hpp>

void window_size_callback(GLFWwindow *window, int width, int height);

// 设置窗口大小
const unsigned int Window_width = 1600;
const unsigned int Window_height = 1200;

int main()
{
    // 实例化GLFW窗口
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    //下面这条语句是为了适应苹果系统
#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif

    // 创建一个窗口对象，这个窗口对象存放了所有和窗口相关的数据，而且会被GLFW的其他函数频繁地用到。
    // 此外增加 if (window == NULL) 判断窗口是否创建成功
    GLFWwindow *window = glfwCreateWindow(Window_width, Window_height, "ImGui Triangle", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    glfwSetFramebufferSizeCallback(window, window_size_callback);
    glfwSwapInterval(1);

    //初始化gl3w
    gl3wInit();

    //创建并绑定ImGui
    ImGui::CreateContext();
    ImGuiIO &io = ImGui::GetIO();
    (void)io;
    ImGui_ImplGlfwGL3_Init(window, true);
    ImGui::StyleColorsDark();

    //初始化各种数据
    bool ImGui = true;
    bool the_same_color = false;
    bool draw_trangle_without_render = false;
    bool draw_trangle = false;
    bool bonus_draw_line = false;
    bool bonus_draw_another_trangle = false;
    unsigned int VBO, VAO, EBO;
    bool show_demo_window = true;
    //创建一个VAO，并将它设为当前对象
    GLuint VertexArrayID;
    glGenVertexArrays(1, &VertexArrayID);
    //绑定顶点数组对象
    glBindVertexArray(VertexArrayID);

    // 加载shader文件，创建并编译GLSL程序
    GLuint programID = LoadShaders("SimpleVertexShader.vertexshader", "SimpleFragmentShader.fragmentshader");
    ImVec4 v1 = ImVec4(-0.25f, -0.25f, 0.0f, 1.00f);
    ImVec4 v2 = ImVec4(0.25f, -0.25f, 0.0f, 1.00f);
    ImVec4 v3 = ImVec4(0.0f, 0.25f, 0.0f, 1.00f);

    //定义顶点缓冲，并将顶点缓冲传给OpenGL
    GLuint vertexbuffer;

    // 渲染循环
    while (!glfwWindowShouldClose(window))
    {
        GLfloat g_vertex_buffer_data[] = {
            v1.x,
            v1.y,
            v1.z,
            v2.x,
            v2.y,
            v2.z,
            v3.x,
            v3.y,
            v3.z,
        };
        glGenBuffers(1, &vertexbuffer);
        // 把我们的顶点数组复制到一个顶点缓冲中，供OpenGL使用
        glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data), g_vertex_buffer_data, GL_STATIC_DRAW);

        // 创建ImGui
        glfwPollEvents();
        ImGui_ImplGlfwGL3_NewFrame();
        ImGui::Begin("change vertex", &ImGui, ImGuiWindowFlags_MenuBar);
        ImGui::SliderFloat("", &v3.y, -1.0f, 1.0f, "v3.y = %.3f");

        ImGui::End();

        if (show_demo_window)
        {
            ImGui::SetNextWindowPos(ImVec2(650, 20), ImGuiCond_FirstUseEver); // Normally user code doesn't need/want to call this because positions are saved in .ini file anyway. Here we just want to make the demo initial state a bit more friendly!
            ImGui::ShowDemoWindow(&show_demo_window);
        }
        // 渲染窗口颜色
        int view_width, view_height;
        glfwGetFramebufferSize(window, &view_width, &view_height);
        glViewport(0, 0, view_width, view_height);
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        ImGui::Render();
        ImGui_ImplGlfwGL3_RenderDrawData(ImGui::GetDrawData());

        glUseProgram(programID);

        // 1rst attribute buffer : vertices
        glEnableVertexAttribArray(0);

        glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
        //设定顶点属性指针
        glVertexAttribPointer(
            0,        // attribute 0. No particular reason for 0, but must match the layout in the shader.
            3,        // size
            GL_FLOAT, // type
            GL_FALSE, // normalized?
            0,        // stride
            (void *)0 // array buffer offset
        );

        // 画三角形
        glDrawArrays(GL_TRIANGLES, 0, 3); // 3 indices starting at 0 -> 1 triangle

        glDisableVertexAttribArray(0);

        // 双缓冲。前缓冲保存着最终输出的图像，它会在屏幕上显示；而所有的的渲染指令都会在后缓冲上绘制。
        glfwSwapBuffers(window);
    }

    // 释放VAO、VBO、EBO资源
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    glDeleteBuffers(1, &EBO);

    // 释放ImGui资源
    ImGui_ImplGlfwGL3_Shutdown();
    ImGui::DestroyContext();

    // 清除所有申请的glfw资源
    glfwTerminate();
    return 0;
}

void window_size_callback(GLFWwindow *window, int width, int height)
{
    glViewport(0, 0, width, height);
}