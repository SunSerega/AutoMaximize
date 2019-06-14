﻿
//*****************************************************************************************************\\
// Copyright (©) Cergey Latchenko ( github.com/SunSerega | forum.mmcs.sfedu.ru/u/sun_serega )
// This code is distributed under the Unlicense
// For details see LICENSE file or this:
// https://github.com/SunSerega/POCGL/blob/master/LICENSE
//*****************************************************************************************************\\
// Copyright (©) Сергей Латченко ( github.com/SunSerega | forum.mmcs.sfedu.ru/u/sun_serega )
// Этот код распространяется под Unlicense
// Для деталей смотрите в файл LICENSE или это:
// https://github.com/SunSerega/POCGL/blob/master/LICENSE
//*****************************************************************************************************\\

///
/// Код переведён отсюда:
/// https://github.com/KhronosGroup/OpenGL-Registry
///
/// Справка:
/// https://www.khronos.org/registry/OpenGL/specs/gl/glspec44.core.pdf
///
/// Если чего то не хватает - писать сюда:
/// https://github.com/SunSerega/POCGL/issues
///
unit OpenGL;

uses System;
uses System.Runtime.InteropServices;

{$region Основные типы}

type
  
  GLsync = IntPtr;
  
  ///0=false, остальное=true
  GLboolean                     = UInt32;
  
type
  OpenGLException = class(Exception)
    
    constructor(text: string) :=
    inherited Create($'Ошибка OpenGL: "{text}"');
    
  end;
  
{$endregion Основные типы}

{$region Энумы} type
  
  {$region case Result of}
  
  //R
  ErrorCode = record
    public val: UInt32;
    
    public const NO_ERROR =                                 $0;
    public const INVALID_ENUM =                             $500;
    public const INVALID_VALUE =                            $501;
    public const INVALID_OPERATION =                        $502;
    public const STACK_OVERFLOW =                           $503;
    public const STACK_UNDERFLOW =                          $504;
    public const OUT_OF_MEMORY =                            $505;
    public const INVALID_FRAMEBUFFER_OPERATION =            $506;
    
    public function ToString: string; override;
    begin
      var res := typeof(ErrorCode).GetFields.Where(fi->fi.IsLiteral).FirstOrDefault(prop->integer(prop.GetValue(nil)) = self.val);
      Result := res=nil?
        $'ErrorCode[${self.val:X}]':
        res.Name.ToWords('_').Select(w->w[1].ToUpper+w.Substring(1).ToLower).JoinIntoString;
    end;
    
    public procedure RaiseIfError :=
    if val<>NO_ERROR then raise new OpenGLException(self.ToString);
    
  end;
  
  {$endregion case Result of}
  
{$endregion Энумы}

{$region Делегаты}

type
  [UnmanagedFunctionPointer(CallingConvention.StdCall)]
  
{$endregion Делегаты}

type
  gl = static class
    
    {$region Разное}
    
    public static function GetError: ErrorCode;
    external 'opengl32.dll' name 'glGetError';
    
    {$endregion Разное}
    
    {$region }
    
    {$endregion }
    
    {$region общие настройки настройки}
    
    static procedure Hint(target: UInt32; mode: UInt32);
    external 'opengl32.dll' name 'glHint';
    
    static procedure CullFace(mode: UInt32);
    external 'opengl32.dll' name 'glCullFace';
    
    static procedure FrontFace(mode: UInt32);
    external 'opengl32.dll' name 'glFrontFace';
    
    static procedure LineWidth(width: single);
    external 'opengl32.dll' name 'glLineWidth';
    
    static procedure PointSize(size: single);
    external 'opengl32.dll' name 'glPointSize';
    
    {$endregion общие настройки настройки}
    
    static procedure PolygonMode(face: UInt32; mode: UInt32);
    external 'opengl32.dll' name 'glPolygonMode';
    
    static procedure Scissor(x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glScissor';
    
    static procedure TexParameterf(target: UInt32; pname: UInt32; param: single);
    external 'opengl32.dll' name 'glTexParameterf';
    
    static procedure TexParameterfv(target: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glTexParameterfv';
    
    static procedure TexParameteri(target: UInt32; pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glTexParameteri';
    
    static procedure TexParameteriv(target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glTexParameteriv';
    
    static procedure TexImage1D(target: UInt32; level: Int32; internalformat: Int32; width: Int32; border: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTexImage1D';
    
    static procedure TexImage2D(target: UInt32; level: Int32; internalformat: Int32; width: Int32; height: Int32; border: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTexImage2D';
    
    static procedure DrawBuffer(buf: UInt32);
    external 'opengl32.dll' name 'glDrawBuffer';
    
    static procedure Clear(mask: UInt32);
    external 'opengl32.dll' name 'glClear';
    
    static procedure ClearColor(red: single; green: single; blue: single; alpha: single);
    external 'opengl32.dll' name 'glClearColor';
    
    static procedure ClearStencil(s: Int32);
    external 'opengl32.dll' name 'glClearStencil';
    
    static procedure ClearDepth(depth: real);
    external 'opengl32.dll' name 'glClearDepth';
    
    static procedure StencilMask(mask: UInt32);
    external 'opengl32.dll' name 'glStencilMask';
    
    static procedure ColorMask(red: GLboolean; green: GLboolean; blue: GLboolean; alpha: GLboolean);
    external 'opengl32.dll' name 'glColorMask';
    
    static procedure DepthMask(flag: GLboolean);
    external 'opengl32.dll' name 'glDepthMask';
    
    static procedure Disable(cap: UInt32);
    external 'opengl32.dll' name 'glDisable';
    
    static procedure Enable(cap: UInt32);
    external 'opengl32.dll' name 'glEnable';
    
    static procedure Finish;
    external 'opengl32.dll' name 'glFinish';
    
    static procedure Flush;
    external 'opengl32.dll' name 'glFlush';
    
    static procedure BlendFunc(sfactor: UInt32; dfactor: UInt32);
    external 'opengl32.dll' name 'glBlendFunc';
    
    static procedure LogicOp(opcode: UInt32);
    external 'opengl32.dll' name 'glLogicOp';
    
    static procedure StencilFunc(func: UInt32; ref: Int32; mask: UInt32);
    external 'opengl32.dll' name 'glStencilFunc';
    
    static procedure StencilOp(fail: UInt32; zfail: UInt32; zpass: UInt32);
    external 'opengl32.dll' name 'glStencilOp';
    
    static procedure DepthFunc(func: UInt32);
    external 'opengl32.dll' name 'glDepthFunc';
    
    static procedure PixelStoref(pname: UInt32; param: single);
    external 'opengl32.dll' name 'glPixelStoref';
    
    static procedure PixelStorei(pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glPixelStorei';
    
    static procedure ReadBuffer(src: UInt32);
    external 'opengl32.dll' name 'glReadBuffer';
    
    static procedure ReadPixels(x: Int32; y: Int32; width: Int32; height: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glReadPixels';
    
    static procedure GetBooleanv(pname: UInt32; data: ^GLboolean);
    external 'opengl32.dll' name 'glGetBooleanv';
    
    static procedure GetDoublev(pname: UInt32; data: ^real);
    external 'opengl32.dll' name 'glGetDoublev';
    
    static procedure GetFloatv(pname: UInt32; data: ^single);
    external 'opengl32.dll' name 'glGetFloatv';
    
    static procedure GetIntegerv(pname: UInt32; data: ^Int32);
    external 'opengl32.dll' name 'glGetIntegerv';
    
    static function GetString(name: UInt32): ^Byte;
    external 'opengl32.dll' name 'glGetString';
    
    static procedure GetTexImage(target: UInt32; level: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glGetTexImage';
    
    static procedure GetTexParameterfv(target: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetTexParameterfv';
    
    static procedure GetTexParameteriv(target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetTexParameteriv';
    
    static procedure GetTexLevelParameterfv(target: UInt32; level: Int32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetTexLevelParameterfv';
    
    static procedure GetTexLevelParameteriv(target: UInt32; level: Int32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetTexLevelParameteriv';
    
    static function IsEnabled(cap: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsEnabled';
    
    static procedure DepthRange(n: real; f: real);
    external 'opengl32.dll' name 'glDepthRange';
    
    static procedure Viewport(x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glViewport';
    
    static procedure DrawArrays(mode: UInt32; first: Int32; count: Int32);
    external 'opengl32.dll' name 'glDrawArrays';
    
    static procedure DrawElements(mode: UInt32; count: Int32; &type: UInt32; indices: pointer);
    external 'opengl32.dll' name 'glDrawElements';
    
    static procedure GetPointerv(pname: UInt32; &params: ^IntPtr);
    external 'opengl32.dll' name 'glGetPointerv';
    
    static procedure PolygonOffset(factor: single; units: single);
    external 'opengl32.dll' name 'glPolygonOffset';
    
    static procedure CopyTexImage1D(target: UInt32; level: Int32; internalformat: UInt32; x: Int32; y: Int32; width: Int32; border: Int32);
    external 'opengl32.dll' name 'glCopyTexImage1D';
    
    static procedure CopyTexImage2D(target: UInt32; level: Int32; internalformat: UInt32; x: Int32; y: Int32; width: Int32; height: Int32; border: Int32);
    external 'opengl32.dll' name 'glCopyTexImage2D';
    
    static procedure CopyTexSubImage1D(target: UInt32; level: Int32; xoffset: Int32; x: Int32; y: Int32; width: Int32);
    external 'opengl32.dll' name 'glCopyTexSubImage1D';
    
    static procedure CopyTexSubImage2D(target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glCopyTexSubImage2D';
    
    static procedure TexSubImage1D(target: UInt32; level: Int32; xoffset: Int32; width: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTexSubImage1D';
    
    static procedure TexSubImage2D(target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; width: Int32; height: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTexSubImage2D';
    
    static procedure BindTexture(target: UInt32; texture: UInt32);
    external 'opengl32.dll' name 'glBindTexture';
    
    static procedure DeleteTextures(n: Int32; textures: ^UInt32);
    external 'opengl32.dll' name 'glDeleteTextures';
    
    static procedure GenTextures(n: Int32; textures: ^UInt32);
    external 'opengl32.dll' name 'glGenTextures';
    
    static function IsTexture(texture: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsTexture';
    
    static procedure DrawRangeElements(mode: UInt32; start: UInt32; &end: UInt32; count: Int32; &type: UInt32; indices: pointer);
    external 'opengl32.dll' name 'glDrawRangeElements';
    
    static procedure TexImage3D(target: UInt32; level: Int32; internalformat: Int32; width: Int32; height: Int32; depth: Int32; border: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTexImage3D';
    
    static procedure TexSubImage3D(target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTexSubImage3D';
    
    static procedure CopyTexSubImage3D(target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glCopyTexSubImage3D';
    
    static procedure ActiveTexture(texture: UInt32);
    external 'opengl32.dll' name 'glActiveTexture';
    
    static procedure SampleCoverage(value: single; invert: GLboolean);
    external 'opengl32.dll' name 'glSampleCoverage';
    
    static procedure CompressedTexImage3D(target: UInt32; level: Int32; internalformat: UInt32; width: Int32; height: Int32; depth: Int32; border: Int32; imageSize: Int32; data: pointer);
    external 'opengl32.dll' name 'glCompressedTexImage3D';
    
    static procedure CompressedTexImage2D(target: UInt32; level: Int32; internalformat: UInt32; width: Int32; height: Int32; border: Int32; imageSize: Int32; data: pointer);
    external 'opengl32.dll' name 'glCompressedTexImage2D';
    
    static procedure CompressedTexImage1D(target: UInt32; level: Int32; internalformat: UInt32; width: Int32; border: Int32; imageSize: Int32; data: pointer);
    external 'opengl32.dll' name 'glCompressedTexImage1D';
    
    static procedure CompressedTexSubImage3D(target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; format: UInt32; imageSize: Int32; data: pointer);
    external 'opengl32.dll' name 'glCompressedTexSubImage3D';
    
    static procedure CompressedTexSubImage2D(target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; width: Int32; height: Int32; format: UInt32; imageSize: Int32; data: pointer);
    external 'opengl32.dll' name 'glCompressedTexSubImage2D';
    
    static procedure CompressedTexSubImage1D(target: UInt32; level: Int32; xoffset: Int32; width: Int32; format: UInt32; imageSize: Int32; data: pointer);
    external 'opengl32.dll' name 'glCompressedTexSubImage1D';
    
    static procedure GetCompressedTexImage(target: UInt32; level: Int32; img: pointer);
    external 'opengl32.dll' name 'glGetCompressedTexImage';
    
    static procedure BlendFuncSeparate(sfactorRGB: UInt32; dfactorRGB: UInt32; sfactorAlpha: UInt32; dfactorAlpha: UInt32);
    external 'opengl32.dll' name 'glBlendFuncSeparate';
    
    static procedure MultiDrawArrays(mode: UInt32; first: ^Int32; count: ^Int32; drawcount: Int32);
    external 'opengl32.dll' name 'glMultiDrawArrays';
    
    static procedure MultiDrawElements(mode: UInt32; count: ^Int32; &type: UInt32; indices: ^IntPtr; drawcount: Int32);
    external 'opengl32.dll' name 'glMultiDrawElements';
    
    static procedure PointParameterf(pname: UInt32; param: single);
    external 'opengl32.dll' name 'glPointParameterf';
    
    static procedure PointParameterfv(pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glPointParameterfv';
    
    static procedure PointParameteri(pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glPointParameteri';
    
    static procedure PointParameteriv(pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glPointParameteriv';
    
    static procedure BlendColor(red: single; green: single; blue: single; alpha: single);
    external 'opengl32.dll' name 'glBlendColor';
    
    static procedure BlendEquation(mode: UInt32);
    external 'opengl32.dll' name 'glBlendEquation';
    
    static procedure GenQueries(n: Int32; ids: ^UInt32);
    external 'opengl32.dll' name 'glGenQueries';
    
    static procedure DeleteQueries(n: Int32; ids: ^UInt32);
    external 'opengl32.dll' name 'glDeleteQueries';
    
    static function IsQuery(id: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsQuery';
    
    static procedure BeginQuery(target: UInt32; id: UInt32);
    external 'opengl32.dll' name 'glBeginQuery';
    
    static procedure EndQuery(target: UInt32);
    external 'opengl32.dll' name 'glEndQuery';
    
    static procedure GetQueryiv(target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetQueryiv';
    
    static procedure GetQueryObjectiv(id: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetQueryObjectiv';
    
    static procedure GetQueryObjectuiv(id: UInt32; pname: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetQueryObjectuiv';
    
    static procedure BindBuffer(target: UInt32; buffer: UInt32);
    external 'opengl32.dll' name 'glBindBuffer';
    
    static procedure DeleteBuffers(n: Int32; buffers: ^UInt32);
    external 'opengl32.dll' name 'glDeleteBuffers';
    
    static procedure GenBuffers(n: Int32; buffers: ^UInt32);
    external 'opengl32.dll' name 'glGenBuffers';
    
    static function IsBuffer(buffer: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsBuffer';
    
    static procedure BufferData(target: UInt32; size: UIntPtr; data: pointer; usage: UInt32);
    external 'opengl32.dll' name 'glBufferData';
    
    static procedure BufferSubData(target: UInt32; offset: IntPtr; size: UIntPtr; data: pointer);
    external 'opengl32.dll' name 'glBufferSubData';
    
    static procedure GetBufferSubData(target: UInt32; offset: IntPtr; size: UIntPtr; data: pointer);
    external 'opengl32.dll' name 'glGetBufferSubData';
    
    static function MapBuffer(target: UInt32; access: UInt32): pointer;
    external 'opengl32.dll' name 'glMapBuffer';
    
    static function UnmapBuffer(target: UInt32): GLboolean;
    external 'opengl32.dll' name 'glUnmapBuffer';
    
    static procedure GetBufferParameteriv(target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetBufferParameteriv';
    
    static procedure GetBufferPointerv(target: UInt32; pname: UInt32; &params: ^IntPtr);
    external 'opengl32.dll' name 'glGetBufferPointerv';
    
    static procedure BlendEquationSeparate(modeRGB: UInt32; modeAlpha: UInt32);
    external 'opengl32.dll' name 'glBlendEquationSeparate';
    
    static procedure DrawBuffers(n: Int32; bufs: ^UInt32);
    external 'opengl32.dll' name 'glDrawBuffers';
    
    static procedure StencilOpSeparate(face: UInt32; sfail: UInt32; dpfail: UInt32; dppass: UInt32);
    external 'opengl32.dll' name 'glStencilOpSeparate';
    
    static procedure StencilFuncSeparate(face: UInt32; func: UInt32; ref: Int32; mask: UInt32);
    external 'opengl32.dll' name 'glStencilFuncSeparate';
    
    static procedure StencilMaskSeparate(face: UInt32; mask: UInt32);
    external 'opengl32.dll' name 'glStencilMaskSeparate';
    
    static procedure AttachShader(&program: UInt32; shader: UInt32);
    external 'opengl32.dll' name 'glAttachShader';
    
    static procedure BindAttribLocation(&program: UInt32; index: UInt32; name: ^SByte);
    external 'opengl32.dll' name 'glBindAttribLocation';
    
    static procedure CompileShader(shader: UInt32);
    external 'opengl32.dll' name 'glCompileShader';
    
    static function CreateProgram: UInt32;
    external 'opengl32.dll' name 'glCreateProgram';
    
    static function CreateShader(&type: UInt32): UInt32;
    external 'opengl32.dll' name 'glCreateShader';
    
    static procedure DeleteProgram(&program: UInt32);
    external 'opengl32.dll' name 'glDeleteProgram';
    
    static procedure DeleteShader(shader: UInt32);
    external 'opengl32.dll' name 'glDeleteShader';
    
    static procedure DetachShader(&program: UInt32; shader: UInt32);
    external 'opengl32.dll' name 'glDetachShader';
    
    static procedure DisableVertexAttribArray(index: UInt32);
    external 'opengl32.dll' name 'glDisableVertexAttribArray';
    
    static procedure EnableVertexAttribArray(index: UInt32);
    external 'opengl32.dll' name 'glEnableVertexAttribArray';
    
    static procedure GetActiveAttrib(&program: UInt32; index: UInt32; bufSize: Int32; length: ^Int32; size: ^Int32; &type: ^UInt32; name: ^SByte);
    external 'opengl32.dll' name 'glGetActiveAttrib';
    
    static procedure GetActiveUniform(&program: UInt32; index: UInt32; bufSize: Int32; length: ^Int32; size: ^Int32; &type: ^UInt32; name: ^SByte);
    external 'opengl32.dll' name 'glGetActiveUniform';
    
    static procedure GetAttachedShaders(&program: UInt32; maxCount: Int32; count: ^Int32; shaders: ^UInt32);
    external 'opengl32.dll' name 'glGetAttachedShaders';
    
    static function GetAttribLocation(&program: UInt32; name: ^SByte): Int32;
    external 'opengl32.dll' name 'glGetAttribLocation';
    
    static procedure GetProgramiv(&program: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetProgramiv';
    
    static procedure GetProgramInfoLog(&program: UInt32; bufSize: Int32; length: ^Int32; infoLog: ^SByte);
    external 'opengl32.dll' name 'glGetProgramInfoLog';
    
    static procedure GetShaderiv(shader: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetShaderiv';
    
    static procedure GetShaderInfoLog(shader: UInt32; bufSize: Int32; length: ^Int32; infoLog: ^SByte);
    external 'opengl32.dll' name 'glGetShaderInfoLog';
    
    static procedure GetShaderSource(shader: UInt32; bufSize: Int32; length: ^Int32; source: ^SByte);
    external 'opengl32.dll' name 'glGetShaderSource';
    
    static function GetUniformLocation(&program: UInt32; name: ^SByte): Int32;
    external 'opengl32.dll' name 'glGetUniformLocation';
    
    static procedure GetUniformfv(&program: UInt32; location: Int32; &params: ^single);
    external 'opengl32.dll' name 'glGetUniformfv';
    
    static procedure GetUniformiv(&program: UInt32; location: Int32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetUniformiv';
    
    static procedure GetVertexAttribdv(index: UInt32; pname: UInt32; &params: ^real);
    external 'opengl32.dll' name 'glGetVertexAttribdv';
    
    static procedure GetVertexAttribfv(index: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetVertexAttribfv';
    
    static procedure GetVertexAttribiv(index: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetVertexAttribiv';
    
    static procedure GetVertexAttribPointerv(index: UInt32; pname: UInt32; pointer: ^IntPtr);
    external 'opengl32.dll' name 'glGetVertexAttribPointerv';
    
    static function IsProgram(&program: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsProgram';
    
    static function IsShader(shader: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsShader';
    
    static procedure LinkProgram(&program: UInt32);
    external 'opengl32.dll' name 'glLinkProgram';
    
    static procedure ShaderSource(shader: UInt32; count: Int32; string: ^^SByte; length: ^Int32);
    external 'opengl32.dll' name 'glShaderSource';
    
    static procedure UseProgram(&program: UInt32);
    external 'opengl32.dll' name 'glUseProgram';
    
    static procedure Uniform1f(location: Int32; v0: single);
    external 'opengl32.dll' name 'glUniform1f';
    
    static procedure Uniform2f(location: Int32; v0: single; v1: single);
    external 'opengl32.dll' name 'glUniform2f';
    
    static procedure Uniform3f(location: Int32; v0: single; v1: single; v2: single);
    external 'opengl32.dll' name 'glUniform3f';
    
    static procedure Uniform4f(location: Int32; v0: single; v1: single; v2: single; v3: single);
    external 'opengl32.dll' name 'glUniform4f';
    
    static procedure Uniform1i(location: Int32; v0: Int32);
    external 'opengl32.dll' name 'glUniform1i';
    
    static procedure Uniform2i(location: Int32; v0: Int32; v1: Int32);
    external 'opengl32.dll' name 'glUniform2i';
    
    static procedure Uniform3i(location: Int32; v0: Int32; v1: Int32; v2: Int32);
    external 'opengl32.dll' name 'glUniform3i';
    
    static procedure Uniform4i(location: Int32; v0: Int32; v1: Int32; v2: Int32; v3: Int32);
    external 'opengl32.dll' name 'glUniform4i';
    
    static procedure Uniform1fv(location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glUniform1fv';
    
    static procedure Uniform2fv(location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glUniform2fv';
    
    static procedure Uniform3fv(location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glUniform3fv';
    
    static procedure Uniform4fv(location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glUniform4fv';
    
    static procedure Uniform1iv(location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glUniform1iv';
    
    static procedure Uniform2iv(location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glUniform2iv';
    
    static procedure Uniform3iv(location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glUniform3iv';
    
    static procedure Uniform4iv(location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glUniform4iv';
    
    static procedure UniformMatrix2fv(location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glUniformMatrix2fv';
    
    static procedure UniformMatrix3fv(location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glUniformMatrix3fv';
    
    static procedure UniformMatrix4fv(location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glUniformMatrix4fv';
    
    static procedure ValidateProgram(&program: UInt32);
    external 'opengl32.dll' name 'glValidateProgram';
    
    static procedure VertexAttrib1d(index: UInt32; x: real);
    external 'opengl32.dll' name 'glVertexAttrib1d';
    
    static procedure VertexAttrib1dv(index: UInt32; v: ^real);
    external 'opengl32.dll' name 'glVertexAttrib1dv';
    
    static procedure VertexAttrib1f(index: UInt32; x: single);
    external 'opengl32.dll' name 'glVertexAttrib1f';
    
    static procedure VertexAttrib1fv(index: UInt32; v: ^single);
    external 'opengl32.dll' name 'glVertexAttrib1fv';
    
    static procedure VertexAttrib1s(index: UInt32; x: Int16);
    external 'opengl32.dll' name 'glVertexAttrib1s';
    
    static procedure VertexAttrib1sv(index: UInt32; v: ^Int16);
    external 'opengl32.dll' name 'glVertexAttrib1sv';
    
    static procedure VertexAttrib2d(index: UInt32; x: real; y: real);
    external 'opengl32.dll' name 'glVertexAttrib2d';
    
    static procedure VertexAttrib2dv(index: UInt32; v: ^real);
    external 'opengl32.dll' name 'glVertexAttrib2dv';
    
    static procedure VertexAttrib2f(index: UInt32; x: single; y: single);
    external 'opengl32.dll' name 'glVertexAttrib2f';
    
    static procedure VertexAttrib2fv(index: UInt32; v: ^single);
    external 'opengl32.dll' name 'glVertexAttrib2fv';
    
    static procedure VertexAttrib2s(index: UInt32; x: Int16; y: Int16);
    external 'opengl32.dll' name 'glVertexAttrib2s';
    
    static procedure VertexAttrib2sv(index: UInt32; v: ^Int16);
    external 'opengl32.dll' name 'glVertexAttrib2sv';
    
    static procedure VertexAttrib3d(index: UInt32; x: real; y: real; z: real);
    external 'opengl32.dll' name 'glVertexAttrib3d';
    
    static procedure VertexAttrib3dv(index: UInt32; v: ^real);
    external 'opengl32.dll' name 'glVertexAttrib3dv';
    
    static procedure VertexAttrib3f(index: UInt32; x: single; y: single; z: single);
    external 'opengl32.dll' name 'glVertexAttrib3f';
    
    static procedure VertexAttrib3fv(index: UInt32; v: ^single);
    external 'opengl32.dll' name 'glVertexAttrib3fv';
    
    static procedure VertexAttrib3s(index: UInt32; x: Int16; y: Int16; z: Int16);
    external 'opengl32.dll' name 'glVertexAttrib3s';
    
    static procedure VertexAttrib3sv(index: UInt32; v: ^Int16);
    external 'opengl32.dll' name 'glVertexAttrib3sv';
    
    static procedure VertexAttrib4Nbv(index: UInt32; v: ^SByte);
    external 'opengl32.dll' name 'glVertexAttrib4Nbv';
    
    static procedure VertexAttrib4Niv(index: UInt32; v: ^Int32);
    external 'opengl32.dll' name 'glVertexAttrib4Niv';
    
    static procedure VertexAttrib4Nsv(index: UInt32; v: ^Int16);
    external 'opengl32.dll' name 'glVertexAttrib4Nsv';
    
    static procedure VertexAttrib4Nub(index: UInt32; x: Byte; y: Byte; z: Byte; w: Byte);
    external 'opengl32.dll' name 'glVertexAttrib4Nub';
    
    static procedure VertexAttrib4Nubv(index: UInt32; v: ^Byte);
    external 'opengl32.dll' name 'glVertexAttrib4Nubv';
    
    static procedure VertexAttrib4Nuiv(index: UInt32; v: ^UInt32);
    external 'opengl32.dll' name 'glVertexAttrib4Nuiv';
    
    static procedure VertexAttrib4Nusv(index: UInt32; v: ^UInt16);
    external 'opengl32.dll' name 'glVertexAttrib4Nusv';
    
    static procedure VertexAttrib4bv(index: UInt32; v: ^SByte);
    external 'opengl32.dll' name 'glVertexAttrib4bv';
    
    static procedure VertexAttrib4d(index: UInt32; x: real; y: real; z: real; w: real);
    external 'opengl32.dll' name 'glVertexAttrib4d';
    
    static procedure VertexAttrib4dv(index: UInt32; v: ^real);
    external 'opengl32.dll' name 'glVertexAttrib4dv';
    
    static procedure VertexAttrib4f(index: UInt32; x: single; y: single; z: single; w: single);
    external 'opengl32.dll' name 'glVertexAttrib4f';
    
    static procedure VertexAttrib4fv(index: UInt32; v: ^single);
    external 'opengl32.dll' name 'glVertexAttrib4fv';
    
    static procedure VertexAttrib4iv(index: UInt32; v: ^Int32);
    external 'opengl32.dll' name 'glVertexAttrib4iv';
    
    static procedure VertexAttrib4s(index: UInt32; x: Int16; y: Int16; z: Int16; w: Int16);
    external 'opengl32.dll' name 'glVertexAttrib4s';
    
    static procedure VertexAttrib4sv(index: UInt32; v: ^Int16);
    external 'opengl32.dll' name 'glVertexAttrib4sv';
    
    static procedure VertexAttrib4ubv(index: UInt32; v: ^Byte);
    external 'opengl32.dll' name 'glVertexAttrib4ubv';
    
    static procedure VertexAttrib4uiv(index: UInt32; v: ^UInt32);
    external 'opengl32.dll' name 'glVertexAttrib4uiv';
    
    static procedure VertexAttrib4usv(index: UInt32; v: ^UInt16);
    external 'opengl32.dll' name 'glVertexAttrib4usv';
    
    static procedure VertexAttribPointer(index: UInt32; size: Int32; &type: UInt32; normalized: GLboolean; stride: Int32; _pointer: pointer);
    external 'opengl32.dll' name 'glVertexAttribPointer';
    
    static procedure UniformMatrix2x3fv(location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glUniformMatrix2x3fv';
    
    static procedure UniformMatrix3x2fv(location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glUniformMatrix3x2fv';
    
    static procedure UniformMatrix2x4fv(location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glUniformMatrix2x4fv';
    
    static procedure UniformMatrix4x2fv(location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glUniformMatrix4x2fv';
    
    static procedure UniformMatrix3x4fv(location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glUniformMatrix3x4fv';
    
    static procedure UniformMatrix4x3fv(location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glUniformMatrix4x3fv';
    
    static procedure ColorMaski(index: UInt32; r: GLboolean; g: GLboolean; b: GLboolean; a: GLboolean);
    external 'opengl32.dll' name 'glColorMaski';
    
    static procedure GetBooleani_v(target: UInt32; index: UInt32; data: ^GLboolean);
    external 'opengl32.dll' name 'glGetBooleani_v';
    
    static procedure GetIntegeri_v(target: UInt32; index: UInt32; data: ^Int32);
    external 'opengl32.dll' name 'glGetIntegeri_v';
    
    static procedure Enablei(target: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glEnablei';
    
    static procedure Disablei(target: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glDisablei';
    
    static function IsEnabledi(target: UInt32; index: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsEnabledi';
    
    static procedure BeginTransformFeedback(primitiveMode: UInt32);
    external 'opengl32.dll' name 'glBeginTransformFeedback';
    
    static procedure EndTransformFeedback;
    external 'opengl32.dll' name 'glEndTransformFeedback';
    
    static procedure BindBufferRange(target: UInt32; index: UInt32; buffer: UInt32; offset: IntPtr; size: UIntPtr);
    external 'opengl32.dll' name 'glBindBufferRange';
    
    static procedure BindBufferBase(target: UInt32; index: UInt32; buffer: UInt32);
    external 'opengl32.dll' name 'glBindBufferBase';
    
    static procedure TransformFeedbackVaryings(&program: UInt32; count: Int32; varyings: ^^SByte; bufferMode: UInt32);
    external 'opengl32.dll' name 'glTransformFeedbackVaryings';
    
    static procedure GetTransformFeedbackVarying(&program: UInt32; index: UInt32; bufSize: Int32; length: ^Int32; size: ^Int32; &type: ^UInt32; name: ^SByte);
    external 'opengl32.dll' name 'glGetTransformFeedbackVarying';
    
    static procedure ClampColor(target: UInt32; clamp: UInt32);
    external 'opengl32.dll' name 'glClampColor';
    
    static procedure BeginConditionalRender(id: UInt32; mode: UInt32);
    external 'opengl32.dll' name 'glBeginConditionalRender';
    
    static procedure EndConditionalRender;
    external 'opengl32.dll' name 'glEndConditionalRender';
    
    static procedure VertexAttribIPointer(index: UInt32; size: Int32; &type: UInt32; stride: Int32; _pointer: pointer);
    external 'opengl32.dll' name 'glVertexAttribIPointer';
    
    static procedure GetVertexAttribIiv(index: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetVertexAttribIiv';
    
    static procedure GetVertexAttribIuiv(index: UInt32; pname: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetVertexAttribIuiv';
    
    static procedure VertexAttribI1i(index: UInt32; x: Int32);
    external 'opengl32.dll' name 'glVertexAttribI1i';
    
    static procedure VertexAttribI2i(index: UInt32; x: Int32; y: Int32);
    external 'opengl32.dll' name 'glVertexAttribI2i';
    
    static procedure VertexAttribI3i(index: UInt32; x: Int32; y: Int32; z: Int32);
    external 'opengl32.dll' name 'glVertexAttribI3i';
    
    static procedure VertexAttribI4i(index: UInt32; x: Int32; y: Int32; z: Int32; w: Int32);
    external 'opengl32.dll' name 'glVertexAttribI4i';
    
    static procedure VertexAttribI1ui(index: UInt32; x: UInt32);
    external 'opengl32.dll' name 'glVertexAttribI1ui';
    
    static procedure VertexAttribI2ui(index: UInt32; x: UInt32; y: UInt32);
    external 'opengl32.dll' name 'glVertexAttribI2ui';
    
    static procedure VertexAttribI3ui(index: UInt32; x: UInt32; y: UInt32; z: UInt32);
    external 'opengl32.dll' name 'glVertexAttribI3ui';
    
    static procedure VertexAttribI4ui(index: UInt32; x: UInt32; y: UInt32; z: UInt32; w: UInt32);
    external 'opengl32.dll' name 'glVertexAttribI4ui';
    
    static procedure VertexAttribI1iv(index: UInt32; v: ^Int32);
    external 'opengl32.dll' name 'glVertexAttribI1iv';
    
    static procedure VertexAttribI2iv(index: UInt32; v: ^Int32);
    external 'opengl32.dll' name 'glVertexAttribI2iv';
    
    static procedure VertexAttribI3iv(index: UInt32; v: ^Int32);
    external 'opengl32.dll' name 'glVertexAttribI3iv';
    
    static procedure VertexAttribI4iv(index: UInt32; v: ^Int32);
    external 'opengl32.dll' name 'glVertexAttribI4iv';
    
    static procedure VertexAttribI1uiv(index: UInt32; v: ^UInt32);
    external 'opengl32.dll' name 'glVertexAttribI1uiv';
    
    static procedure VertexAttribI2uiv(index: UInt32; v: ^UInt32);
    external 'opengl32.dll' name 'glVertexAttribI2uiv';
    
    static procedure VertexAttribI3uiv(index: UInt32; v: ^UInt32);
    external 'opengl32.dll' name 'glVertexAttribI3uiv';
    
    static procedure VertexAttribI4uiv(index: UInt32; v: ^UInt32);
    external 'opengl32.dll' name 'glVertexAttribI4uiv';
    
    static procedure VertexAttribI4bv(index: UInt32; v: ^SByte);
    external 'opengl32.dll' name 'glVertexAttribI4bv';
    
    static procedure VertexAttribI4sv(index: UInt32; v: ^Int16);
    external 'opengl32.dll' name 'glVertexAttribI4sv';
    
    static procedure VertexAttribI4ubv(index: UInt32; v: ^Byte);
    external 'opengl32.dll' name 'glVertexAttribI4ubv';
    
    static procedure VertexAttribI4usv(index: UInt32; v: ^UInt16);
    external 'opengl32.dll' name 'glVertexAttribI4usv';
    
    static procedure GetUniformuiv(&program: UInt32; location: Int32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetUniformuiv';
    
    static procedure BindFragDataLocation(&program: UInt32; color: UInt32; name: ^SByte);
    external 'opengl32.dll' name 'glBindFragDataLocation';
    
    static function GetFragDataLocation(&program: UInt32; name: ^SByte): Int32;
    external 'opengl32.dll' name 'glGetFragDataLocation';
    
    static procedure Uniform1ui(location: Int32; v0: UInt32);
    external 'opengl32.dll' name 'glUniform1ui';
    
    static procedure Uniform2ui(location: Int32; v0: UInt32; v1: UInt32);
    external 'opengl32.dll' name 'glUniform2ui';
    
    static procedure Uniform3ui(location: Int32; v0: UInt32; v1: UInt32; v2: UInt32);
    external 'opengl32.dll' name 'glUniform3ui';
    
    static procedure Uniform4ui(location: Int32; v0: UInt32; v1: UInt32; v2: UInt32; v3: UInt32);
    external 'opengl32.dll' name 'glUniform4ui';
    
    static procedure Uniform1uiv(location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glUniform1uiv';
    
    static procedure Uniform2uiv(location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glUniform2uiv';
    
    static procedure Uniform3uiv(location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glUniform3uiv';
    
    static procedure Uniform4uiv(location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glUniform4uiv';
    
    static procedure TexParameterIiv(target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glTexParameterIiv';
    
    static procedure TexParameterIuiv(target: UInt32; pname: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glTexParameterIuiv';
    
    static procedure GetTexParameterIiv(target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetTexParameterIiv';
    
    static procedure GetTexParameterIuiv(target: UInt32; pname: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetTexParameterIuiv';
    
    static procedure ClearBufferiv(buffer: UInt32; drawbuffer: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glClearBufferiv';
    
    static procedure ClearBufferuiv(buffer: UInt32; drawbuffer: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glClearBufferuiv';
    
    static procedure ClearBufferfv(buffer: UInt32; drawbuffer: Int32; value: ^single);
    external 'opengl32.dll' name 'glClearBufferfv';
    
    static procedure ClearBufferfi(buffer: UInt32; drawbuffer: Int32; depth: single; stencil: Int32);
    external 'opengl32.dll' name 'glClearBufferfi';
    
    static function GetStringi(name: UInt32; index: UInt32): ^Byte;
    external 'opengl32.dll' name 'glGetStringi';
    
    static function IsRenderbuffer(renderbuffer: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsRenderbuffer';
    
    static procedure BindRenderbuffer(target: UInt32; renderbuffer: UInt32);
    external 'opengl32.dll' name 'glBindRenderbuffer';
    
    static procedure DeleteRenderbuffers(n: Int32; renderbuffers: ^UInt32);
    external 'opengl32.dll' name 'glDeleteRenderbuffers';
    
    static procedure GenRenderbuffers(n: Int32; renderbuffers: ^UInt32);
    external 'opengl32.dll' name 'glGenRenderbuffers';
    
    static procedure RenderbufferStorage(target: UInt32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glRenderbufferStorage';
    
    static procedure GetRenderbufferParameteriv(target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetRenderbufferParameteriv';
    
    static function IsFramebuffer(framebuffer: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsFramebuffer';
    
    static procedure BindFramebuffer(target: UInt32; framebuffer: UInt32);
    external 'opengl32.dll' name 'glBindFramebuffer';
    
    static procedure DeleteFramebuffers(n: Int32; framebuffers: ^UInt32);
    external 'opengl32.dll' name 'glDeleteFramebuffers';
    
    static procedure GenFramebuffers(n: Int32; framebuffers: ^UInt32);
    external 'opengl32.dll' name 'glGenFramebuffers';
    
    static function CheckFramebufferStatus(target: UInt32): UInt32;
    external 'opengl32.dll' name 'glCheckFramebufferStatus';
    
    static procedure FramebufferTexture1D(target: UInt32; attachment: UInt32; textarget: UInt32; texture: UInt32; level: Int32);
    external 'opengl32.dll' name 'glFramebufferTexture1D';
    
    static procedure FramebufferTexture2D(target: UInt32; attachment: UInt32; textarget: UInt32; texture: UInt32; level: Int32);
    external 'opengl32.dll' name 'glFramebufferTexture2D';
    
    static procedure FramebufferTexture3D(target: UInt32; attachment: UInt32; textarget: UInt32; texture: UInt32; level: Int32; zoffset: Int32);
    external 'opengl32.dll' name 'glFramebufferTexture3D';
    
    static procedure FramebufferRenderbuffer(target: UInt32; attachment: UInt32; renderbuffertarget: UInt32; renderbuffer: UInt32);
    external 'opengl32.dll' name 'glFramebufferRenderbuffer';
    
    static procedure GetFramebufferAttachmentParameteriv(target: UInt32; attachment: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetFramebufferAttachmentParameteriv';
    
    static procedure GenerateMipmap(target: UInt32);
    external 'opengl32.dll' name 'glGenerateMipmap';
    
    static procedure BlitFramebuffer(srcX0: Int32; srcY0: Int32; srcX1: Int32; srcY1: Int32; dstX0: Int32; dstY0: Int32; dstX1: Int32; dstY1: Int32; mask: UInt32; filter: UInt32);
    external 'opengl32.dll' name 'glBlitFramebuffer';
    
    static procedure RenderbufferStorageMultisample(target: UInt32; samples: Int32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glRenderbufferStorageMultisample';
    
    static procedure FramebufferTextureLayer(target: UInt32; attachment: UInt32; texture: UInt32; level: Int32; layer: Int32);
    external 'opengl32.dll' name 'glFramebufferTextureLayer';
    
    static function MapBufferRange(target: UInt32; offset: IntPtr; length: UIntPtr; access: UInt32): pointer;
    external 'opengl32.dll' name 'glMapBufferRange';
    
    static procedure FlushMappedBufferRange(target: UInt32; offset: IntPtr; length: UIntPtr);
    external 'opengl32.dll' name 'glFlushMappedBufferRange';
    
    static procedure BindVertexArray(&array: UInt32);
    external 'opengl32.dll' name 'glBindVertexArray';
    
    static procedure DeleteVertexArrays(n: Int32; arrays: ^UInt32);
    external 'opengl32.dll' name 'glDeleteVertexArrays';
    
    static procedure GenVertexArrays(n: Int32; arrays: ^UInt32);
    external 'opengl32.dll' name 'glGenVertexArrays';
    
    static function IsVertexArray(&array: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsVertexArray';
    
    static procedure DrawArraysInstanced(mode: UInt32; first: Int32; count: Int32; instancecount: Int32);
    external 'opengl32.dll' name 'glDrawArraysInstanced';
    
    static procedure DrawElementsInstanced(mode: UInt32; count: Int32; &type: UInt32; indices: pointer; instancecount: Int32);
    external 'opengl32.dll' name 'glDrawElementsInstanced';
    
    static procedure TexBuffer(target: UInt32; internalformat: UInt32; buffer: UInt32);
    external 'opengl32.dll' name 'glTexBuffer';
    
    static procedure PrimitiveRestartIndex(index: UInt32);
    external 'opengl32.dll' name 'glPrimitiveRestartIndex';
    
    static procedure CopyBufferSubData(readTarget: UInt32; writeTarget: UInt32; readOffset: IntPtr; writeOffset: IntPtr; size: UIntPtr);
    external 'opengl32.dll' name 'glCopyBufferSubData';
    
    static procedure GetUniformIndices(&program: UInt32; uniformCount: Int32; uniformNames: ^^SByte; uniformIndices: ^UInt32);
    external 'opengl32.dll' name 'glGetUniformIndices';
    
    static procedure GetActiveUniformsiv(&program: UInt32; uniformCount: Int32; uniformIndices: ^UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetActiveUniformsiv';
    
    static procedure GetActiveUniformName(&program: UInt32; uniformIndex: UInt32; bufSize: Int32; length: ^Int32; uniformName: ^SByte);
    external 'opengl32.dll' name 'glGetActiveUniformName';
    
    static function GetUniformBlockIndex(&program: UInt32; uniformBlockName: ^SByte): UInt32;
    external 'opengl32.dll' name 'glGetUniformBlockIndex';
    
    static procedure GetActiveUniformBlockiv(&program: UInt32; uniformBlockIndex: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetActiveUniformBlockiv';
    
    static procedure GetActiveUniformBlockName(&program: UInt32; uniformBlockIndex: UInt32; bufSize: Int32; length: ^Int32; uniformBlockName: ^SByte);
    external 'opengl32.dll' name 'glGetActiveUniformBlockName';
    
    static procedure UniformBlockBinding(&program: UInt32; uniformBlockIndex: UInt32; uniformBlockBinding: UInt32);
    external 'opengl32.dll' name 'glUniformBlockBinding';
    
    static procedure DrawElementsBaseVertex(mode: UInt32; count: Int32; &type: UInt32; indices: pointer; basevertex: Int32);
    external 'opengl32.dll' name 'glDrawElementsBaseVertex';
    
    static procedure DrawRangeElementsBaseVertex(mode: UInt32; start: UInt32; &end: UInt32; count: Int32; &type: UInt32; indices: pointer; basevertex: Int32);
    external 'opengl32.dll' name 'glDrawRangeElementsBaseVertex';
    
    static procedure DrawElementsInstancedBaseVertex(mode: UInt32; count: Int32; &type: UInt32; indices: pointer; instancecount: Int32; basevertex: Int32);
    external 'opengl32.dll' name 'glDrawElementsInstancedBaseVertex';
    
    static procedure MultiDrawElementsBaseVertex(mode: UInt32; count: ^Int32; &type: UInt32; indices: ^IntPtr; drawcount: Int32; basevertex: ^Int32);
    external 'opengl32.dll' name 'glMultiDrawElementsBaseVertex';
    
    static procedure ProvokingVertex(mode: UInt32);
    external 'opengl32.dll' name 'glProvokingVertex';
    
    static function FenceSync(condition: UInt32; flags: UInt32): GLsync;
    external 'opengl32.dll' name 'glFenceSync';
    
    static function IsSync(sync: GLsync): GLboolean;
    external 'opengl32.dll' name 'glIsSync';
    
    static procedure DeleteSync(sync: GLsync);
    external 'opengl32.dll' name 'glDeleteSync';
    
    static function ClientWaitSync(sync: GLsync; flags: UInt32; timeout: UInt64): UInt32;
    external 'opengl32.dll' name 'glClientWaitSync';
    
    static procedure WaitSync(sync: GLsync; flags: UInt32; timeout: UInt64);
    external 'opengl32.dll' name 'glWaitSync';
    
    static procedure GetInteger64v(pname: UInt32; data: ^Int64);
    external 'opengl32.dll' name 'glGetInteger64v';
    
    static procedure GetSynciv(sync: GLsync; pname: UInt32; bufSize: Int32; length: ^Int32; values: ^Int32);
    external 'opengl32.dll' name 'glGetSynciv';
    
    static procedure GetInteger64i_v(target: UInt32; index: UInt32; data: ^Int64);
    external 'opengl32.dll' name 'glGetInteger64i_v';
    
    static procedure GetBufferParameteri64v(target: UInt32; pname: UInt32; &params: ^Int64);
    external 'opengl32.dll' name 'glGetBufferParameteri64v';
    
    static procedure FramebufferTexture(target: UInt32; attachment: UInt32; texture: UInt32; level: Int32);
    external 'opengl32.dll' name 'glFramebufferTexture';
    
    static procedure TexImage2DMultisample(target: UInt32; samples: Int32; internalformat: UInt32; width: Int32; height: Int32; fixedsamplelocations: GLboolean);
    external 'opengl32.dll' name 'glTexImage2DMultisample';
    
    static procedure TexImage3DMultisample(target: UInt32; samples: Int32; internalformat: UInt32; width: Int32; height: Int32; depth: Int32; fixedsamplelocations: GLboolean);
    external 'opengl32.dll' name 'glTexImage3DMultisample';
    
    static procedure GetMultisamplefv(pname: UInt32; index: UInt32; val: ^single);
    external 'opengl32.dll' name 'glGetMultisamplefv';
    
    static procedure SampleMaski(maskNumber: UInt32; mask: UInt32);
    external 'opengl32.dll' name 'glSampleMaski';
    
    static procedure BindFragDataLocationIndexed(&program: UInt32; colorNumber: UInt32; index: UInt32; name: ^SByte);
    external 'opengl32.dll' name 'glBindFragDataLocationIndexed';
    
    static function GetFragDataIndex(&program: UInt32; name: ^SByte): Int32;
    external 'opengl32.dll' name 'glGetFragDataIndex';
    
    static procedure GenSamplers(count: Int32; samplers: ^UInt32);
    external 'opengl32.dll' name 'glGenSamplers';
    
    static procedure DeleteSamplers(count: Int32; samplers: ^UInt32);
    external 'opengl32.dll' name 'glDeleteSamplers';
    
    static function IsSampler(sampler: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsSampler';
    
    static procedure BindSampler(&unit: UInt32; sampler: UInt32);
    external 'opengl32.dll' name 'glBindSampler';
    
    static procedure SamplerParameteri(sampler: UInt32; pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glSamplerParameteri';
    
    static procedure SamplerParameteriv(sampler: UInt32; pname: UInt32; param: ^Int32);
    external 'opengl32.dll' name 'glSamplerParameteriv';
    
    static procedure SamplerParameterf(sampler: UInt32; pname: UInt32; param: single);
    external 'opengl32.dll' name 'glSamplerParameterf';
    
    static procedure SamplerParameterfv(sampler: UInt32; pname: UInt32; param: ^single);
    external 'opengl32.dll' name 'glSamplerParameterfv';
    
    static procedure SamplerParameterIiv(sampler: UInt32; pname: UInt32; param: ^Int32);
    external 'opengl32.dll' name 'glSamplerParameterIiv';
    
    static procedure SamplerParameterIuiv(sampler: UInt32; pname: UInt32; param: ^UInt32);
    external 'opengl32.dll' name 'glSamplerParameterIuiv';
    
    static procedure GetSamplerParameteriv(sampler: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetSamplerParameteriv';
    
    static procedure GetSamplerParameterIiv(sampler: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetSamplerParameterIiv';
    
    static procedure GetSamplerParameterfv(sampler: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetSamplerParameterfv';
    
    static procedure GetSamplerParameterIuiv(sampler: UInt32; pname: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetSamplerParameterIuiv';
    
    static procedure QueryCounter(id: UInt32; target: UInt32);
    external 'opengl32.dll' name 'glQueryCounter';
    
    static procedure GetQueryObjecti64v(id: UInt32; pname: UInt32; &params: ^Int64);
    external 'opengl32.dll' name 'glGetQueryObjecti64v';
    
    static procedure GetQueryObjectui64v(id: UInt32; pname: UInt32; &params: ^UInt64);
    external 'opengl32.dll' name 'glGetQueryObjectui64v';
    
    static procedure VertexAttribDivisor(index: UInt32; divisor: UInt32);
    external 'opengl32.dll' name 'glVertexAttribDivisor';
    
    static procedure VertexAttribP1ui(index: UInt32; &type: UInt32; normalized: GLboolean; value: UInt32);
    external 'opengl32.dll' name 'glVertexAttribP1ui';
    
    static procedure VertexAttribP1uiv(index: UInt32; &type: UInt32; normalized: GLboolean; value: ^UInt32);
    external 'opengl32.dll' name 'glVertexAttribP1uiv';
    
    static procedure VertexAttribP2ui(index: UInt32; &type: UInt32; normalized: GLboolean; value: UInt32);
    external 'opengl32.dll' name 'glVertexAttribP2ui';
    
    static procedure VertexAttribP2uiv(index: UInt32; &type: UInt32; normalized: GLboolean; value: ^UInt32);
    external 'opengl32.dll' name 'glVertexAttribP2uiv';
    
    static procedure VertexAttribP3ui(index: UInt32; &type: UInt32; normalized: GLboolean; value: UInt32);
    external 'opengl32.dll' name 'glVertexAttribP3ui';
    
    static procedure VertexAttribP3uiv(index: UInt32; &type: UInt32; normalized: GLboolean; value: ^UInt32);
    external 'opengl32.dll' name 'glVertexAttribP3uiv';
    
    static procedure VertexAttribP4ui(index: UInt32; &type: UInt32; normalized: GLboolean; value: UInt32);
    external 'opengl32.dll' name 'glVertexAttribP4ui';
    
    static procedure VertexAttribP4uiv(index: UInt32; &type: UInt32; normalized: GLboolean; value: ^UInt32);
    external 'opengl32.dll' name 'glVertexAttribP4uiv';
    
    static procedure MinSampleShading(value: single);
    external 'opengl32.dll' name 'glMinSampleShading';
    
    static procedure BlendEquationi(buf: UInt32; mode: UInt32);
    external 'opengl32.dll' name 'glBlendEquationi';
    
    static procedure BlendEquationSeparatei(buf: UInt32; modeRGB: UInt32; modeAlpha: UInt32);
    external 'opengl32.dll' name 'glBlendEquationSeparatei';
    
    static procedure BlendFunci(buf: UInt32; src: UInt32; dst: UInt32);
    external 'opengl32.dll' name 'glBlendFunci';
    
    static procedure BlendFuncSeparatei(buf: UInt32; srcRGB: UInt32; dstRGB: UInt32; srcAlpha: UInt32; dstAlpha: UInt32);
    external 'opengl32.dll' name 'glBlendFuncSeparatei';
    
    static procedure DrawArraysIndirect(mode: UInt32; indirect: pointer);
    external 'opengl32.dll' name 'glDrawArraysIndirect';
    
    static procedure DrawElementsIndirect(mode: UInt32; &type: UInt32; indirect: pointer);
    external 'opengl32.dll' name 'glDrawElementsIndirect';
    
    static procedure Uniform1d(location: Int32; x: real);
    external 'opengl32.dll' name 'glUniform1d';
    
    static procedure Uniform2d(location: Int32; x: real; y: real);
    external 'opengl32.dll' name 'glUniform2d';
    
    static procedure Uniform3d(location: Int32; x: real; y: real; z: real);
    external 'opengl32.dll' name 'glUniform3d';
    
    static procedure Uniform4d(location: Int32; x: real; y: real; z: real; w: real);
    external 'opengl32.dll' name 'glUniform4d';
    
    static procedure Uniform1dv(location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glUniform1dv';
    
    static procedure Uniform2dv(location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glUniform2dv';
    
    static procedure Uniform3dv(location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glUniform3dv';
    
    static procedure Uniform4dv(location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glUniform4dv';
    
    static procedure UniformMatrix2dv(location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glUniformMatrix2dv';
    
    static procedure UniformMatrix3dv(location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glUniformMatrix3dv';
    
    static procedure UniformMatrix4dv(location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glUniformMatrix4dv';
    
    static procedure UniformMatrix2x3dv(location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glUniformMatrix2x3dv';
    
    static procedure UniformMatrix2x4dv(location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glUniformMatrix2x4dv';
    
    static procedure UniformMatrix3x2dv(location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glUniformMatrix3x2dv';
    
    static procedure UniformMatrix3x4dv(location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glUniformMatrix3x4dv';
    
    static procedure UniformMatrix4x2dv(location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glUniformMatrix4x2dv';
    
    static procedure UniformMatrix4x3dv(location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glUniformMatrix4x3dv';
    
    static procedure GetUniformdv(&program: UInt32; location: Int32; &params: ^real);
    external 'opengl32.dll' name 'glGetUniformdv';
    
    static function GetSubroutineUniformLocation(&program: UInt32; shadertype: UInt32; name: ^SByte): Int32;
    external 'opengl32.dll' name 'glGetSubroutineUniformLocation';
    
    static function GetSubroutineIndex(&program: UInt32; shadertype: UInt32; name: ^SByte): UInt32;
    external 'opengl32.dll' name 'glGetSubroutineIndex';
    
    static procedure GetActiveSubroutineUniformiv(&program: UInt32; shadertype: UInt32; index: UInt32; pname: UInt32; values: ^Int32);
    external 'opengl32.dll' name 'glGetActiveSubroutineUniformiv';
    
    static procedure GetActiveSubroutineUniformName(&program: UInt32; shadertype: UInt32; index: UInt32; bufsize: Int32; length: ^Int32; name: ^SByte);
    external 'opengl32.dll' name 'glGetActiveSubroutineUniformName';
    
    static procedure GetActiveSubroutineName(&program: UInt32; shadertype: UInt32; index: UInt32; bufsize: Int32; length: ^Int32; name: ^SByte);
    external 'opengl32.dll' name 'glGetActiveSubroutineName';
    
    static procedure UniformSubroutinesuiv(shadertype: UInt32; count: Int32; indices: ^UInt32);
    external 'opengl32.dll' name 'glUniformSubroutinesuiv';
    
    static procedure GetUniformSubroutineuiv(shadertype: UInt32; location: Int32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetUniformSubroutineuiv';
    
    static procedure GetProgramStageiv(&program: UInt32; shadertype: UInt32; pname: UInt32; values: ^Int32);
    external 'opengl32.dll' name 'glGetProgramStageiv';
    
    static procedure PatchParameteri(pname: UInt32; value: Int32);
    external 'opengl32.dll' name 'glPatchParameteri';
    
    static procedure PatchParameterfv(pname: UInt32; values: ^single);
    external 'opengl32.dll' name 'glPatchParameterfv';
    
    static procedure BindTransformFeedback(target: UInt32; id: UInt32);
    external 'opengl32.dll' name 'glBindTransformFeedback';
    
    static procedure DeleteTransformFeedbacks(n: Int32; ids: ^UInt32);
    external 'opengl32.dll' name 'glDeleteTransformFeedbacks';
    
    static procedure GenTransformFeedbacks(n: Int32; ids: ^UInt32);
    external 'opengl32.dll' name 'glGenTransformFeedbacks';
    
    static function IsTransformFeedback(id: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsTransformFeedback';
    
    static procedure PauseTransformFeedback;
    external 'opengl32.dll' name 'glPauseTransformFeedback';
    
    static procedure ResumeTransformFeedback;
    external 'opengl32.dll' name 'glResumeTransformFeedback';
    
    static procedure DrawTransformFeedback(mode: UInt32; id: UInt32);
    external 'opengl32.dll' name 'glDrawTransformFeedback';
    
    static procedure DrawTransformFeedbackStream(mode: UInt32; id: UInt32; stream: UInt32);
    external 'opengl32.dll' name 'glDrawTransformFeedbackStream';
    
    static procedure BeginQueryIndexed(target: UInt32; index: UInt32; id: UInt32);
    external 'opengl32.dll' name 'glBeginQueryIndexed';
    
    static procedure EndQueryIndexed(target: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glEndQueryIndexed';
    
    static procedure GetQueryIndexediv(target: UInt32; index: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetQueryIndexediv';
    
    static procedure ReleaseShaderCompiler;
    external 'opengl32.dll' name 'glReleaseShaderCompiler';
    
    static procedure ShaderBinary(count: Int32; shaders: ^UInt32; binaryformat: UInt32; binary: pointer; length: Int32);
    external 'opengl32.dll' name 'glShaderBinary';
    
    static procedure GetShaderPrecisionFormat(shadertype: UInt32; precisiontype: UInt32; range: ^Int32; precision: ^Int32);
    external 'opengl32.dll' name 'glGetShaderPrecisionFormat';
    
    static procedure DepthRangef(n: single; f: single);
    external 'opengl32.dll' name 'glDepthRangef';
    
    static procedure ClearDepthf(d: single);
    external 'opengl32.dll' name 'glClearDepthf';
    
    static procedure GetProgramBinary(&program: UInt32; bufSize: Int32; length: ^Int32; binaryFormat: ^UInt32; binary: pointer);
    external 'opengl32.dll' name 'glGetProgramBinary';
    
    static procedure ProgramBinary(&program: UInt32; binaryFormat: UInt32; binary: pointer; length: Int32);
    external 'opengl32.dll' name 'glProgramBinary';
    
    static procedure ProgramParameteri(&program: UInt32; pname: UInt32; value: Int32);
    external 'opengl32.dll' name 'glProgramParameteri';
    
    static procedure UseProgramStages(pipeline: UInt32; stages: UInt32; &program: UInt32);
    external 'opengl32.dll' name 'glUseProgramStages';
    
    static procedure ActiveShaderProgram(pipeline: UInt32; &program: UInt32);
    external 'opengl32.dll' name 'glActiveShaderProgram';
    
    static function CreateShaderProgramv(&type: UInt32; count: Int32; strings: ^^SByte): UInt32;
    external 'opengl32.dll' name 'glCreateShaderProgramv';
    
    static procedure BindProgramPipeline(pipeline: UInt32);
    external 'opengl32.dll' name 'glBindProgramPipeline';
    
    static procedure DeleteProgramPipelines(n: Int32; pipelines: ^UInt32);
    external 'opengl32.dll' name 'glDeleteProgramPipelines';
    
    static procedure GenProgramPipelines(n: Int32; pipelines: ^UInt32);
    external 'opengl32.dll' name 'glGenProgramPipelines';
    
    static function IsProgramPipeline(pipeline: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsProgramPipeline';
    
    static procedure GetProgramPipelineiv(pipeline: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetProgramPipelineiv';
    
    static procedure ProgramUniform1i(&program: UInt32; location: Int32; v0: Int32);
    external 'opengl32.dll' name 'glProgramUniform1i';
    
    static procedure ProgramUniform1iv(&program: UInt32; location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glProgramUniform1iv';
    
    static procedure ProgramUniform1f(&program: UInt32; location: Int32; v0: single);
    external 'opengl32.dll' name 'glProgramUniform1f';
    
    static procedure ProgramUniform1fv(&program: UInt32; location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glProgramUniform1fv';
    
    static procedure ProgramUniform1d(&program: UInt32; location: Int32; v0: real);
    external 'opengl32.dll' name 'glProgramUniform1d';
    
    static procedure ProgramUniform1dv(&program: UInt32; location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glProgramUniform1dv';
    
    static procedure ProgramUniform1ui(&program: UInt32; location: Int32; v0: UInt32);
    external 'opengl32.dll' name 'glProgramUniform1ui';
    
    static procedure ProgramUniform1uiv(&program: UInt32; location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glProgramUniform1uiv';
    
    static procedure ProgramUniform2i(&program: UInt32; location: Int32; v0: Int32; v1: Int32);
    external 'opengl32.dll' name 'glProgramUniform2i';
    
    static procedure ProgramUniform2iv(&program: UInt32; location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glProgramUniform2iv';
    
    static procedure ProgramUniform2f(&program: UInt32; location: Int32; v0: single; v1: single);
    external 'opengl32.dll' name 'glProgramUniform2f';
    
    static procedure ProgramUniform2fv(&program: UInt32; location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glProgramUniform2fv';
    
    static procedure ProgramUniform2d(&program: UInt32; location: Int32; v0: real; v1: real);
    external 'opengl32.dll' name 'glProgramUniform2d';
    
    static procedure ProgramUniform2dv(&program: UInt32; location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glProgramUniform2dv';
    
    static procedure ProgramUniform2ui(&program: UInt32; location: Int32; v0: UInt32; v1: UInt32);
    external 'opengl32.dll' name 'glProgramUniform2ui';
    
    static procedure ProgramUniform2uiv(&program: UInt32; location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glProgramUniform2uiv';
    
    static procedure ProgramUniform3i(&program: UInt32; location: Int32; v0: Int32; v1: Int32; v2: Int32);
    external 'opengl32.dll' name 'glProgramUniform3i';
    
    static procedure ProgramUniform3iv(&program: UInt32; location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glProgramUniform3iv';
    
    static procedure ProgramUniform3f(&program: UInt32; location: Int32; v0: single; v1: single; v2: single);
    external 'opengl32.dll' name 'glProgramUniform3f';
    
    static procedure ProgramUniform3fv(&program: UInt32; location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glProgramUniform3fv';
    
    static procedure ProgramUniform3d(&program: UInt32; location: Int32; v0: real; v1: real; v2: real);
    external 'opengl32.dll' name 'glProgramUniform3d';
    
    static procedure ProgramUniform3dv(&program: UInt32; location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glProgramUniform3dv';
    
    static procedure ProgramUniform3ui(&program: UInt32; location: Int32; v0: UInt32; v1: UInt32; v2: UInt32);
    external 'opengl32.dll' name 'glProgramUniform3ui';
    
    static procedure ProgramUniform3uiv(&program: UInt32; location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glProgramUniform3uiv';
    
    static procedure ProgramUniform4i(&program: UInt32; location: Int32; v0: Int32; v1: Int32; v2: Int32; v3: Int32);
    external 'opengl32.dll' name 'glProgramUniform4i';
    
    static procedure ProgramUniform4iv(&program: UInt32; location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glProgramUniform4iv';
    
    static procedure ProgramUniform4f(&program: UInt32; location: Int32; v0: single; v1: single; v2: single; v3: single);
    external 'opengl32.dll' name 'glProgramUniform4f';
    
    static procedure ProgramUniform4fv(&program: UInt32; location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glProgramUniform4fv';
    
    static procedure ProgramUniform4d(&program: UInt32; location: Int32; v0: real; v1: real; v2: real; v3: real);
    external 'opengl32.dll' name 'glProgramUniform4d';
    
    static procedure ProgramUniform4dv(&program: UInt32; location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glProgramUniform4dv';
    
    static procedure ProgramUniform4ui(&program: UInt32; location: Int32; v0: UInt32; v1: UInt32; v2: UInt32; v3: UInt32);
    external 'opengl32.dll' name 'glProgramUniform4ui';
    
    static procedure ProgramUniform4uiv(&program: UInt32; location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glProgramUniform4uiv';
    
    static procedure ProgramUniformMatrix2fv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix2fv';
    
    static procedure ProgramUniformMatrix3fv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix3fv';
    
    static procedure ProgramUniformMatrix4fv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix4fv';
    
    static procedure ProgramUniformMatrix2dv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix2dv';
    
    static procedure ProgramUniformMatrix3dv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix3dv';
    
    static procedure ProgramUniformMatrix4dv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix4dv';
    
    static procedure ProgramUniformMatrix2x3fv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix2x3fv';
    
    static procedure ProgramUniformMatrix3x2fv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix3x2fv';
    
    static procedure ProgramUniformMatrix2x4fv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix2x4fv';
    
    static procedure ProgramUniformMatrix4x2fv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix4x2fv';
    
    static procedure ProgramUniformMatrix3x4fv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix3x4fv';
    
    static procedure ProgramUniformMatrix4x3fv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix4x3fv';
    
    static procedure ProgramUniformMatrix2x3dv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix2x3dv';
    
    static procedure ProgramUniformMatrix3x2dv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix3x2dv';
    
    static procedure ProgramUniformMatrix2x4dv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix2x4dv';
    
    static procedure ProgramUniformMatrix4x2dv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix4x2dv';
    
    static procedure ProgramUniformMatrix3x4dv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix3x4dv';
    
    static procedure ProgramUniformMatrix4x3dv(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix4x3dv';
    
    static procedure ValidateProgramPipeline(pipeline: UInt32);
    external 'opengl32.dll' name 'glValidateProgramPipeline';
    
    static procedure GetProgramPipelineInfoLog(pipeline: UInt32; bufSize: Int32; length: ^Int32; infoLog: ^SByte);
    external 'opengl32.dll' name 'glGetProgramPipelineInfoLog';
    
    static procedure VertexAttribL1d(index: UInt32; x: real);
    external 'opengl32.dll' name 'glVertexAttribL1d';
    
    static procedure VertexAttribL2d(index: UInt32; x: real; y: real);
    external 'opengl32.dll' name 'glVertexAttribL2d';
    
    static procedure VertexAttribL3d(index: UInt32; x: real; y: real; z: real);
    external 'opengl32.dll' name 'glVertexAttribL3d';
    
    static procedure VertexAttribL4d(index: UInt32; x: real; y: real; z: real; w: real);
    external 'opengl32.dll' name 'glVertexAttribL4d';
    
    static procedure VertexAttribL1dv(index: UInt32; v: ^real);
    external 'opengl32.dll' name 'glVertexAttribL1dv';
    
    static procedure VertexAttribL2dv(index: UInt32; v: ^real);
    external 'opengl32.dll' name 'glVertexAttribL2dv';
    
    static procedure VertexAttribL3dv(index: UInt32; v: ^real);
    external 'opengl32.dll' name 'glVertexAttribL3dv';
    
    static procedure VertexAttribL4dv(index: UInt32; v: ^real);
    external 'opengl32.dll' name 'glVertexAttribL4dv';
    
    static procedure VertexAttribLPointer(index: UInt32; size: Int32; &type: UInt32; stride: Int32; _pointer: pointer);
    external 'opengl32.dll' name 'glVertexAttribLPointer';
    
    static procedure GetVertexAttribLdv(index: UInt32; pname: UInt32; &params: ^real);
    external 'opengl32.dll' name 'glGetVertexAttribLdv';
    
    static procedure ViewportArrayv(first: UInt32; count: Int32; v: ^single);
    external 'opengl32.dll' name 'glViewportArrayv';
    
    static procedure ViewportIndexedf(index: UInt32; x: single; y: single; w: single; h: single);
    external 'opengl32.dll' name 'glViewportIndexedf';
    
    static procedure ViewportIndexedfv(index: UInt32; v: ^single);
    external 'opengl32.dll' name 'glViewportIndexedfv';
    
    static procedure ScissorArrayv(first: UInt32; count: Int32; v: ^Int32);
    external 'opengl32.dll' name 'glScissorArrayv';
    
    static procedure ScissorIndexed(index: UInt32; left: Int32; bottom: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glScissorIndexed';
    
    static procedure ScissorIndexedv(index: UInt32; v: ^Int32);
    external 'opengl32.dll' name 'glScissorIndexedv';
    
    static procedure DepthRangeArrayv(first: UInt32; count: Int32; v: ^real);
    external 'opengl32.dll' name 'glDepthRangeArrayv';
    
    static procedure DepthRangeIndexed(index: UInt32; n: real; f: real);
    external 'opengl32.dll' name 'glDepthRangeIndexed';
    
    static procedure GetFloati_v(target: UInt32; index: UInt32; data: ^single);
    external 'opengl32.dll' name 'glGetFloati_v';
    
    static procedure GetDoublei_v(target: UInt32; index: UInt32; data: ^real);
    external 'opengl32.dll' name 'glGetDoublei_v';
    
    static procedure DrawArraysInstancedBaseInstance(mode: UInt32; first: Int32; count: Int32; instancecount: Int32; baseinstance: UInt32);
    external 'opengl32.dll' name 'glDrawArraysInstancedBaseInstance';
    
    static procedure DrawElementsInstancedBaseInstance(mode: UInt32; count: Int32; &type: UInt32; indices: pointer; instancecount: Int32; baseinstance: UInt32);
    external 'opengl32.dll' name 'glDrawElementsInstancedBaseInstance';
    
    static procedure DrawElementsInstancedBaseVertexBaseInstance(mode: UInt32; count: Int32; &type: UInt32; indices: pointer; instancecount: Int32; basevertex: Int32; baseinstance: UInt32);
    external 'opengl32.dll' name 'glDrawElementsInstancedBaseVertexBaseInstance';
    
    static procedure GetInternalformativ(target: UInt32; internalformat: UInt32; pname: UInt32; bufSize: Int32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetInternalformativ';
    
    static procedure GetActiveAtomicCounterBufferiv(&program: UInt32; bufferIndex: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetActiveAtomicCounterBufferiv';
    
    static procedure BindImageTexture(&unit: UInt32; texture: UInt32; level: Int32; layered: GLboolean; layer: Int32; access: UInt32; format: UInt32);
    external 'opengl32.dll' name 'glBindImageTexture';
    
    static procedure MemoryBarrier(barriers: UInt32);
    external 'opengl32.dll' name 'glMemoryBarrier';
    
    static procedure TexStorage1D(target: UInt32; levels: Int32; internalformat: UInt32; width: Int32);
    external 'opengl32.dll' name 'glTexStorage1D';
    
    static procedure TexStorage2D(target: UInt32; levels: Int32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glTexStorage2D';
    
    static procedure TexStorage3D(target: UInt32; levels: Int32; internalformat: UInt32; width: Int32; height: Int32; depth: Int32);
    external 'opengl32.dll' name 'glTexStorage3D';
    
    static procedure DrawTransformFeedbackInstanced(mode: UInt32; id: UInt32; instancecount: Int32);
    external 'opengl32.dll' name 'glDrawTransformFeedbackInstanced';
    
    static procedure DrawTransformFeedbackStreamInstanced(mode: UInt32; id: UInt32; stream: UInt32; instancecount: Int32);
    external 'opengl32.dll' name 'glDrawTransformFeedbackStreamInstanced';
    
    static procedure ClearBufferData(target: UInt32; internalformat: UInt32; format: UInt32; &type: UInt32; data: pointer);
    external 'opengl32.dll' name 'glClearBufferData';
    
    static procedure ClearBufferSubData(target: UInt32; internalformat: UInt32; offset: IntPtr; size: UIntPtr; format: UInt32; &type: UInt32; data: pointer);
    external 'opengl32.dll' name 'glClearBufferSubData';
    
    static procedure DispatchCompute(num_groups_x: UInt32; num_groups_y: UInt32; num_groups_z: UInt32);
    external 'opengl32.dll' name 'glDispatchCompute';
    
    static procedure DispatchComputeIndirect(indirect: IntPtr);
    external 'opengl32.dll' name 'glDispatchComputeIndirect';
    
    static procedure CopyImageSubData(srcName: UInt32; srcTarget: UInt32; srcLevel: Int32; srcX: Int32; srcY: Int32; srcZ: Int32; dstName: UInt32; dstTarget: UInt32; dstLevel: Int32; dstX: Int32; dstY: Int32; dstZ: Int32; srcWidth: Int32; srcHeight: Int32; srcDepth: Int32);
    external 'opengl32.dll' name 'glCopyImageSubData';
    
    static procedure FramebufferParameteri(target: UInt32; pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glFramebufferParameteri';
    
    static procedure GetFramebufferParameteriv(target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetFramebufferParameteriv';
    
    static procedure GetInternalformati64v(target: UInt32; internalformat: UInt32; pname: UInt32; bufSize: Int32; &params: ^Int64);
    external 'opengl32.dll' name 'glGetInternalformati64v';
    
    static procedure InvalidateTexSubImage(texture: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32);
    external 'opengl32.dll' name 'glInvalidateTexSubImage';
    
    static procedure InvalidateTexImage(texture: UInt32; level: Int32);
    external 'opengl32.dll' name 'glInvalidateTexImage';
    
    static procedure InvalidateBufferSubData(buffer: UInt32; offset: IntPtr; length: UIntPtr);
    external 'opengl32.dll' name 'glInvalidateBufferSubData';
    
    static procedure InvalidateBufferData(buffer: UInt32);
    external 'opengl32.dll' name 'glInvalidateBufferData';
    
    static procedure InvalidateFramebuffer(target: UInt32; numAttachments: Int32; attachments: ^UInt32);
    external 'opengl32.dll' name 'glInvalidateFramebuffer';
    
    static procedure InvalidateSubFramebuffer(target: UInt32; numAttachments: Int32; attachments: ^UInt32; x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glInvalidateSubFramebuffer';
    
    static procedure MultiDrawArraysIndirect(mode: UInt32; indirect: pointer; drawcount: Int32; stride: Int32);
    external 'opengl32.dll' name 'glMultiDrawArraysIndirect';
    
    static procedure MultiDrawElementsIndirect(mode: UInt32; &type: UInt32; indirect: pointer; drawcount: Int32; stride: Int32);
    external 'opengl32.dll' name 'glMultiDrawElementsIndirect';
    
    static procedure GetProgramInterfaceiv(&program: UInt32; programInterface: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetProgramInterfaceiv';
    
    static function GetProgramResourceIndex(&program: UInt32; programInterface: UInt32; name: ^SByte): UInt32;
    external 'opengl32.dll' name 'glGetProgramResourceIndex';
    
    static procedure GetProgramResourceName(&program: UInt32; programInterface: UInt32; index: UInt32; bufSize: Int32; length: ^Int32; name: ^SByte);
    external 'opengl32.dll' name 'glGetProgramResourceName';
    
    static procedure GetProgramResourceiv(&program: UInt32; programInterface: UInt32; index: UInt32; propCount: Int32; props: ^UInt32; bufSize: Int32; length: ^Int32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetProgramResourceiv';
    
    static function GetProgramResourceLocation(&program: UInt32; programInterface: UInt32; name: ^SByte): Int32;
    external 'opengl32.dll' name 'glGetProgramResourceLocation';
    
    static function GetProgramResourceLocationIndex(&program: UInt32; programInterface: UInt32; name: ^SByte): Int32;
    external 'opengl32.dll' name 'glGetProgramResourceLocationIndex';
    
    static procedure ShaderStorageBlockBinding(&program: UInt32; storageBlockIndex: UInt32; storageBlockBinding: UInt32);
    external 'opengl32.dll' name 'glShaderStorageBlockBinding';
    
    static procedure TexBufferRange(target: UInt32; internalformat: UInt32; buffer: UInt32; offset: IntPtr; size: UIntPtr);
    external 'opengl32.dll' name 'glTexBufferRange';
    
    static procedure TexStorage2DMultisample(target: UInt32; samples: Int32; internalformat: UInt32; width: Int32; height: Int32; fixedsamplelocations: GLboolean);
    external 'opengl32.dll' name 'glTexStorage2DMultisample';
    
    static procedure TexStorage3DMultisample(target: UInt32; samples: Int32; internalformat: UInt32; width: Int32; height: Int32; depth: Int32; fixedsamplelocations: GLboolean);
    external 'opengl32.dll' name 'glTexStorage3DMultisample';
    
    static procedure TextureView(texture: UInt32; target: UInt32; origtexture: UInt32; internalformat: UInt32; minlevel: UInt32; numlevels: UInt32; minlayer: UInt32; numlayers: UInt32);
    external 'opengl32.dll' name 'glTextureView';
    
    static procedure BindVertexBuffer(bindingindex: UInt32; buffer: UInt32; offset: IntPtr; stride: Int32);
    external 'opengl32.dll' name 'glBindVertexBuffer';
    
    static procedure VertexAttribFormat(attribindex: UInt32; size: Int32; &type: UInt32; normalized: GLboolean; relativeoffset: UInt32);
    external 'opengl32.dll' name 'glVertexAttribFormat';
    
    static procedure VertexAttribIFormat(attribindex: UInt32; size: Int32; &type: UInt32; relativeoffset: UInt32);
    external 'opengl32.dll' name 'glVertexAttribIFormat';
    
    static procedure VertexAttribLFormat(attribindex: UInt32; size: Int32; &type: UInt32; relativeoffset: UInt32);
    external 'opengl32.dll' name 'glVertexAttribLFormat';
    
    static procedure VertexAttribBinding(attribindex: UInt32; bindingindex: UInt32);
    external 'opengl32.dll' name 'glVertexAttribBinding';
    
    static procedure VertexBindingDivisor(bindingindex: UInt32; divisor: UInt32);
    external 'opengl32.dll' name 'glVertexBindingDivisor';
    
    static procedure DebugMessageControl(source: UInt32; &type: UInt32; severity: UInt32; count: Int32; ids: ^UInt32; enabled: GLboolean);
    external 'opengl32.dll' name 'glDebugMessageControl';
    
    static procedure DebugMessageInsert(source: UInt32; &type: UInt32; id: UInt32; severity: UInt32; length: Int32; buf: ^SByte);
    external 'opengl32.dll' name 'glDebugMessageInsert';
    
    static procedure DebugMessageCallback(callback: GLDEBUGPROC; userParam: pointer);
    external 'opengl32.dll' name 'glDebugMessageCallback';
    
    static function GetDebugMessageLog(count: UInt32; bufSize: Int32; sources: ^UInt32; types: ^UInt32; ids: ^UInt32; severities: ^UInt32; lengths: ^Int32; messageLog: ^SByte): UInt32;
    external 'opengl32.dll' name 'glGetDebugMessageLog';
    
    static procedure PushDebugGroup(source: UInt32; id: UInt32; length: Int32; message: ^SByte);
    external 'opengl32.dll' name 'glPushDebugGroup';
    
    static procedure PopDebugGroup;
    external 'opengl32.dll' name 'glPopDebugGroup';
    
    static procedure ObjectLabel(identifier: UInt32; name: UInt32; length: Int32; &label: ^SByte);
    external 'opengl32.dll' name 'glObjectLabel';
    
    static procedure GetObjectLabel(identifier: UInt32; name: UInt32; bufSize: Int32; length: ^Int32; &label: ^SByte);
    external 'opengl32.dll' name 'glGetObjectLabel';
    
    static procedure ObjectPtrLabel(ptr: pointer; length: Int32; &label: ^SByte);
    external 'opengl32.dll' name 'glObjectPtrLabel';
    
    static procedure GetObjectPtrLabel(ptr: pointer; bufSize: Int32; length: ^Int32; &label: ^SByte);
    external 'opengl32.dll' name 'glGetObjectPtrLabel';
    
    static procedure BufferStorage(target: UInt32; size: UIntPtr; data: pointer; flags: UInt32);
    external 'opengl32.dll' name 'glBufferStorage';
    
    static procedure ClearTexImage(texture: UInt32; level: Int32; format: UInt32; &type: UInt32; data: pointer);
    external 'opengl32.dll' name 'glClearTexImage';
    
    static procedure ClearTexSubImage(texture: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; format: UInt32; &type: UInt32; data: pointer);
    external 'opengl32.dll' name 'glClearTexSubImage';
    
    static procedure BindBuffersBase(target: UInt32; first: UInt32; count: Int32; buffers: ^UInt32);
    external 'opengl32.dll' name 'glBindBuffersBase';
    
    static procedure BindBuffersRange(target: UInt32; first: UInt32; count: Int32; buffers: ^UInt32; offsets: ^IntPtr; sizes: ^UIntPtr);
    external 'opengl32.dll' name 'glBindBuffersRange';
    
    static procedure BindTextures(first: UInt32; count: Int32; textures: ^UInt32);
    external 'opengl32.dll' name 'glBindTextures';
    
    static procedure BindSamplers(first: UInt32; count: Int32; samplers: ^UInt32);
    external 'opengl32.dll' name 'glBindSamplers';
    
    static procedure BindImageTextures(first: UInt32; count: Int32; textures: ^UInt32);
    external 'opengl32.dll' name 'glBindImageTextures';
    
    static procedure BindVertexBuffers(first: UInt32; count: Int32; buffers: ^UInt32; offsets: ^IntPtr; strides: ^Int32);
    external 'opengl32.dll' name 'glBindVertexBuffers';
    
    static procedure ClipControl(origin: UInt32; depth: UInt32);
    external 'opengl32.dll' name 'glClipControl';
    
    static procedure CreateTransformFeedbacks(n: Int32; ids: ^UInt32);
    external 'opengl32.dll' name 'glCreateTransformFeedbacks';
    
    static procedure TransformFeedbackBufferBase(xfb: UInt32; index: UInt32; buffer: UInt32);
    external 'opengl32.dll' name 'glTransformFeedbackBufferBase';
    
    static procedure TransformFeedbackBufferRange(xfb: UInt32; index: UInt32; buffer: UInt32; offset: IntPtr; size: UIntPtr);
    external 'opengl32.dll' name 'glTransformFeedbackBufferRange';
    
    static procedure GetTransformFeedbackiv(xfb: UInt32; pname: UInt32; param: ^Int32);
    external 'opengl32.dll' name 'glGetTransformFeedbackiv';
    
    static procedure GetTransformFeedbacki_v(xfb: UInt32; pname: UInt32; index: UInt32; param: ^Int32);
    external 'opengl32.dll' name 'glGetTransformFeedbacki_v';
    
    static procedure GetTransformFeedbacki64_v(xfb: UInt32; pname: UInt32; index: UInt32; param: ^Int64);
    external 'opengl32.dll' name 'glGetTransformFeedbacki64_v';
    
    static procedure CreateBuffers(n: Int32; buffers: ^UInt32);
    external 'opengl32.dll' name 'glCreateBuffers';
    
    static procedure NamedBufferStorage(buffer: UInt32; size: UIntPtr; data: pointer; flags: UInt32);
    external 'opengl32.dll' name 'glNamedBufferStorage';
    
    static procedure NamedBufferData(buffer: UInt32; size: UIntPtr; data: pointer; usage: UInt32);
    external 'opengl32.dll' name 'glNamedBufferData';
    
    static procedure NamedBufferSubData(buffer: UInt32; offset: IntPtr; size: UIntPtr; data: pointer);
    external 'opengl32.dll' name 'glNamedBufferSubData';
    
    static procedure CopyNamedBufferSubData(readBuffer: UInt32; writeBuffer: UInt32; readOffset: IntPtr; writeOffset: IntPtr; size: UIntPtr);
    external 'opengl32.dll' name 'glCopyNamedBufferSubData';
    
    static procedure ClearNamedBufferData(buffer: UInt32; internalformat: UInt32; format: UInt32; &type: UInt32; data: pointer);
    external 'opengl32.dll' name 'glClearNamedBufferData';
    
    static procedure ClearNamedBufferSubData(buffer: UInt32; internalformat: UInt32; offset: IntPtr; size: UIntPtr; format: UInt32; &type: UInt32; data: pointer);
    external 'opengl32.dll' name 'glClearNamedBufferSubData';
    
    static function MapNamedBuffer(buffer: UInt32; access: UInt32): pointer;
    external 'opengl32.dll' name 'glMapNamedBuffer';
    
    static function MapNamedBufferRange(buffer: UInt32; offset: IntPtr; length: UIntPtr; access: UInt32): pointer;
    external 'opengl32.dll' name 'glMapNamedBufferRange';
    
    static function UnmapNamedBuffer(buffer: UInt32): GLboolean;
    external 'opengl32.dll' name 'glUnmapNamedBuffer';
    
    static procedure FlushMappedNamedBufferRange(buffer: UInt32; offset: IntPtr; length: UIntPtr);
    external 'opengl32.dll' name 'glFlushMappedNamedBufferRange';
    
    static procedure GetNamedBufferParameteriv(buffer: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetNamedBufferParameteriv';
    
    static procedure GetNamedBufferParameteri64v(buffer: UInt32; pname: UInt32; &params: ^Int64);
    external 'opengl32.dll' name 'glGetNamedBufferParameteri64v';
    
    static procedure GetNamedBufferPointerv(buffer: UInt32; pname: UInt32; &params: ^IntPtr);
    external 'opengl32.dll' name 'glGetNamedBufferPointerv';
    
    static procedure GetNamedBufferSubData(buffer: UInt32; offset: IntPtr; size: UIntPtr; data: pointer);
    external 'opengl32.dll' name 'glGetNamedBufferSubData';
    
    static procedure CreateFramebuffers(n: Int32; framebuffers: ^UInt32);
    external 'opengl32.dll' name 'glCreateFramebuffers';
    
    static procedure NamedFramebufferRenderbuffer(framebuffer: UInt32; attachment: UInt32; renderbuffertarget: UInt32; renderbuffer: UInt32);
    external 'opengl32.dll' name 'glNamedFramebufferRenderbuffer';
    
    static procedure NamedFramebufferParameteri(framebuffer: UInt32; pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glNamedFramebufferParameteri';
    
    static procedure NamedFramebufferTexture(framebuffer: UInt32; attachment: UInt32; texture: UInt32; level: Int32);
    external 'opengl32.dll' name 'glNamedFramebufferTexture';
    
    static procedure NamedFramebufferTextureLayer(framebuffer: UInt32; attachment: UInt32; texture: UInt32; level: Int32; layer: Int32);
    external 'opengl32.dll' name 'glNamedFramebufferTextureLayer';
    
    static procedure NamedFramebufferDrawBuffer(framebuffer: UInt32; buf: UInt32);
    external 'opengl32.dll' name 'glNamedFramebufferDrawBuffer';
    
    static procedure NamedFramebufferDrawBuffers(framebuffer: UInt32; n: Int32; bufs: ^UInt32);
    external 'opengl32.dll' name 'glNamedFramebufferDrawBuffers';
    
    static procedure NamedFramebufferReadBuffer(framebuffer: UInt32; src: UInt32);
    external 'opengl32.dll' name 'glNamedFramebufferReadBuffer';
    
    static procedure InvalidateNamedFramebufferData(framebuffer: UInt32; numAttachments: Int32; attachments: ^UInt32);
    external 'opengl32.dll' name 'glInvalidateNamedFramebufferData';
    
    static procedure InvalidateNamedFramebufferSubData(framebuffer: UInt32; numAttachments: Int32; attachments: ^UInt32; x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glInvalidateNamedFramebufferSubData';
    
    static procedure ClearNamedFramebufferiv(framebuffer: UInt32; buffer: UInt32; drawbuffer: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glClearNamedFramebufferiv';
    
    static procedure ClearNamedFramebufferuiv(framebuffer: UInt32; buffer: UInt32; drawbuffer: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glClearNamedFramebufferuiv';
    
    static procedure ClearNamedFramebufferfv(framebuffer: UInt32; buffer: UInt32; drawbuffer: Int32; value: ^single);
    external 'opengl32.dll' name 'glClearNamedFramebufferfv';
    
    static procedure ClearNamedFramebufferfi(framebuffer: UInt32; buffer: UInt32; drawbuffer: Int32; depth: single; stencil: Int32);
    external 'opengl32.dll' name 'glClearNamedFramebufferfi';
    
    static procedure BlitNamedFramebuffer(readFramebuffer: UInt32; drawFramebuffer: UInt32; srcX0: Int32; srcY0: Int32; srcX1: Int32; srcY1: Int32; dstX0: Int32; dstY0: Int32; dstX1: Int32; dstY1: Int32; mask: UInt32; filter: UInt32);
    external 'opengl32.dll' name 'glBlitNamedFramebuffer';
    
    static function CheckNamedFramebufferStatus(framebuffer: UInt32; target: UInt32): UInt32;
    external 'opengl32.dll' name 'glCheckNamedFramebufferStatus';
    
    static procedure GetNamedFramebufferParameteriv(framebuffer: UInt32; pname: UInt32; param: ^Int32);
    external 'opengl32.dll' name 'glGetNamedFramebufferParameteriv';
    
    static procedure GetNamedFramebufferAttachmentParameteriv(framebuffer: UInt32; attachment: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetNamedFramebufferAttachmentParameteriv';
    
    static procedure CreateRenderbuffers(n: Int32; renderbuffers: ^UInt32);
    external 'opengl32.dll' name 'glCreateRenderbuffers';
    
    static procedure NamedRenderbufferStorage(renderbuffer: UInt32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glNamedRenderbufferStorage';
    
    static procedure NamedRenderbufferStorageMultisample(renderbuffer: UInt32; samples: Int32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glNamedRenderbufferStorageMultisample';
    
    static procedure GetNamedRenderbufferParameteriv(renderbuffer: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetNamedRenderbufferParameteriv';
    
    static procedure CreateTextures(target: UInt32; n: Int32; textures: ^UInt32);
    external 'opengl32.dll' name 'glCreateTextures';
    
    static procedure TextureBuffer(texture: UInt32; internalformat: UInt32; buffer: UInt32);
    external 'opengl32.dll' name 'glTextureBuffer';
    
    static procedure TextureBufferRange(texture: UInt32; internalformat: UInt32; buffer: UInt32; offset: IntPtr; size: UIntPtr);
    external 'opengl32.dll' name 'glTextureBufferRange';
    
    static procedure TextureStorage1D(texture: UInt32; levels: Int32; internalformat: UInt32; width: Int32);
    external 'opengl32.dll' name 'glTextureStorage1D';
    
    static procedure TextureStorage2D(texture: UInt32; levels: Int32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glTextureStorage2D';
    
    static procedure TextureStorage3D(texture: UInt32; levels: Int32; internalformat: UInt32; width: Int32; height: Int32; depth: Int32);
    external 'opengl32.dll' name 'glTextureStorage3D';
    
    static procedure TextureStorage2DMultisample(texture: UInt32; samples: Int32; internalformat: UInt32; width: Int32; height: Int32; fixedsamplelocations: GLboolean);
    external 'opengl32.dll' name 'glTextureStorage2DMultisample';
    
    static procedure TextureStorage3DMultisample(texture: UInt32; samples: Int32; internalformat: UInt32; width: Int32; height: Int32; depth: Int32; fixedsamplelocations: GLboolean);
    external 'opengl32.dll' name 'glTextureStorage3DMultisample';
    
    static procedure TextureSubImage1D(texture: UInt32; level: Int32; xoffset: Int32; width: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTextureSubImage1D';
    
    static procedure TextureSubImage2D(texture: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; width: Int32; height: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTextureSubImage2D';
    
    static procedure TextureSubImage3D(texture: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTextureSubImage3D';
    
    static procedure CompressedTextureSubImage1D(texture: UInt32; level: Int32; xoffset: Int32; width: Int32; format: UInt32; imageSize: Int32; data: pointer);
    external 'opengl32.dll' name 'glCompressedTextureSubImage1D';
    
    static procedure CompressedTextureSubImage2D(texture: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; width: Int32; height: Int32; format: UInt32; imageSize: Int32; data: pointer);
    external 'opengl32.dll' name 'glCompressedTextureSubImage2D';
    
    static procedure CompressedTextureSubImage3D(texture: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; format: UInt32; imageSize: Int32; data: pointer);
    external 'opengl32.dll' name 'glCompressedTextureSubImage3D';
    
    static procedure CopyTextureSubImage1D(texture: UInt32; level: Int32; xoffset: Int32; x: Int32; y: Int32; width: Int32);
    external 'opengl32.dll' name 'glCopyTextureSubImage1D';
    
    static procedure CopyTextureSubImage2D(texture: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glCopyTextureSubImage2D';
    
    static procedure CopyTextureSubImage3D(texture: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glCopyTextureSubImage3D';
    
    static procedure TextureParameterf(texture: UInt32; pname: UInt32; param: single);
    external 'opengl32.dll' name 'glTextureParameterf';
    
    static procedure TextureParameterfv(texture: UInt32; pname: UInt32; param: ^single);
    external 'opengl32.dll' name 'glTextureParameterfv';
    
    static procedure TextureParameteri(texture: UInt32; pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glTextureParameteri';
    
    static procedure TextureParameterIiv(texture: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glTextureParameterIiv';
    
    static procedure TextureParameterIuiv(texture: UInt32; pname: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glTextureParameterIuiv';
    
    static procedure TextureParameteriv(texture: UInt32; pname: UInt32; param: ^Int32);
    external 'opengl32.dll' name 'glTextureParameteriv';
    
    static procedure GenerateTextureMipmap(texture: UInt32);
    external 'opengl32.dll' name 'glGenerateTextureMipmap';
    
    static procedure BindTextureUnit(&unit: UInt32; texture: UInt32);
    external 'opengl32.dll' name 'glBindTextureUnit';
    
    static procedure GetTextureImage(texture: UInt32; level: Int32; format: UInt32; &type: UInt32; bufSize: Int32; pixels: pointer);
    external 'opengl32.dll' name 'glGetTextureImage';
    
    static procedure GetCompressedTextureImage(texture: UInt32; level: Int32; bufSize: Int32; pixels: pointer);
    external 'opengl32.dll' name 'glGetCompressedTextureImage';
    
    static procedure GetTextureLevelParameterfv(texture: UInt32; level: Int32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetTextureLevelParameterfv';
    
    static procedure GetTextureLevelParameteriv(texture: UInt32; level: Int32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetTextureLevelParameteriv';
    
    static procedure GetTextureParameterfv(texture: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetTextureParameterfv';
    
    static procedure GetTextureParameterIiv(texture: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetTextureParameterIiv';
    
    static procedure GetTextureParameterIuiv(texture: UInt32; pname: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetTextureParameterIuiv';
    
    static procedure GetTextureParameteriv(texture: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetTextureParameteriv';
    
    static procedure CreateVertexArrays(n: Int32; arrays: ^UInt32);
    external 'opengl32.dll' name 'glCreateVertexArrays';
    
    static procedure DisableVertexArrayAttrib(vaobj: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glDisableVertexArrayAttrib';
    
    static procedure EnableVertexArrayAttrib(vaobj: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glEnableVertexArrayAttrib';
    
    static procedure VertexArrayElementBuffer(vaobj: UInt32; buffer: UInt32);
    external 'opengl32.dll' name 'glVertexArrayElementBuffer';
    
    static procedure VertexArrayVertexBuffer(vaobj: UInt32; bindingindex: UInt32; buffer: UInt32; offset: IntPtr; stride: Int32);
    external 'opengl32.dll' name 'glVertexArrayVertexBuffer';
    
    static procedure VertexArrayVertexBuffers(vaobj: UInt32; first: UInt32; count: Int32; buffers: ^UInt32; offsets: ^IntPtr; strides: ^Int32);
    external 'opengl32.dll' name 'glVertexArrayVertexBuffers';
    
    static procedure VertexArrayAttribBinding(vaobj: UInt32; attribindex: UInt32; bindingindex: UInt32);
    external 'opengl32.dll' name 'glVertexArrayAttribBinding';
    
    static procedure VertexArrayAttribFormat(vaobj: UInt32; attribindex: UInt32; size: Int32; &type: UInt32; normalized: GLboolean; relativeoffset: UInt32);
    external 'opengl32.dll' name 'glVertexArrayAttribFormat';
    
    static procedure VertexArrayAttribIFormat(vaobj: UInt32; attribindex: UInt32; size: Int32; &type: UInt32; relativeoffset: UInt32);
    external 'opengl32.dll' name 'glVertexArrayAttribIFormat';
    
    static procedure VertexArrayAttribLFormat(vaobj: UInt32; attribindex: UInt32; size: Int32; &type: UInt32; relativeoffset: UInt32);
    external 'opengl32.dll' name 'glVertexArrayAttribLFormat';
    
    static procedure VertexArrayBindingDivisor(vaobj: UInt32; bindingindex: UInt32; divisor: UInt32);
    external 'opengl32.dll' name 'glVertexArrayBindingDivisor';
    
    static procedure GetVertexArrayiv(vaobj: UInt32; pname: UInt32; param: ^Int32);
    external 'opengl32.dll' name 'glGetVertexArrayiv';
    
    static procedure GetVertexArrayIndexediv(vaobj: UInt32; index: UInt32; pname: UInt32; param: ^Int32);
    external 'opengl32.dll' name 'glGetVertexArrayIndexediv';
    
    static procedure GetVertexArrayIndexed64iv(vaobj: UInt32; index: UInt32; pname: UInt32; param: ^Int64);
    external 'opengl32.dll' name 'glGetVertexArrayIndexed64iv';
    
    static procedure CreateSamplers(n: Int32; samplers: ^UInt32);
    external 'opengl32.dll' name 'glCreateSamplers';
    
    static procedure CreateProgramPipelines(n: Int32; pipelines: ^UInt32);
    external 'opengl32.dll' name 'glCreateProgramPipelines';
    
    static procedure CreateQueries(target: UInt32; n: Int32; ids: ^UInt32);
    external 'opengl32.dll' name 'glCreateQueries';
    
    static procedure GetQueryBufferObjecti64v(id: UInt32; buffer: UInt32; pname: UInt32; offset: IntPtr);
    external 'opengl32.dll' name 'glGetQueryBufferObjecti64v';
    
    static procedure GetQueryBufferObjectiv(id: UInt32; buffer: UInt32; pname: UInt32; offset: IntPtr);
    external 'opengl32.dll' name 'glGetQueryBufferObjectiv';
    
    static procedure GetQueryBufferObjectui64v(id: UInt32; buffer: UInt32; pname: UInt32; offset: IntPtr);
    external 'opengl32.dll' name 'glGetQueryBufferObjectui64v';
    
    static procedure GetQueryBufferObjectuiv(id: UInt32; buffer: UInt32; pname: UInt32; offset: IntPtr);
    external 'opengl32.dll' name 'glGetQueryBufferObjectuiv';
    
    static procedure MemoryBarrierByRegion(barriers: UInt32);
    external 'opengl32.dll' name 'glMemoryBarrierByRegion';
    
    static procedure GetTextureSubImage(texture: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; format: UInt32; &type: UInt32; bufSize: Int32; pixels: pointer);
    external 'opengl32.dll' name 'glGetTextureSubImage';
    
    static procedure GetCompressedTextureSubImage(texture: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; bufSize: Int32; pixels: pointer);
    external 'opengl32.dll' name 'glGetCompressedTextureSubImage';
    
    static function GetGraphicsResetStatus: UInt32;
    external 'opengl32.dll' name 'glGetGraphicsResetStatus';
    
    static procedure GetnCompressedTexImage(target: UInt32; lod: Int32; bufSize: Int32; pixels: pointer);
    external 'opengl32.dll' name 'glGetnCompressedTexImage';
    
    static procedure GetnTexImage(target: UInt32; level: Int32; format: UInt32; &type: UInt32; bufSize: Int32; pixels: pointer);
    external 'opengl32.dll' name 'glGetnTexImage';
    
    static procedure GetnUniformdv(&program: UInt32; location: Int32; bufSize: Int32; &params: ^real);
    external 'opengl32.dll' name 'glGetnUniformdv';
    
    static procedure GetnUniformfv(&program: UInt32; location: Int32; bufSize: Int32; &params: ^single);
    external 'opengl32.dll' name 'glGetnUniformfv';
    
    static procedure GetnUniformiv(&program: UInt32; location: Int32; bufSize: Int32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetnUniformiv';
    
    static procedure GetnUniformuiv(&program: UInt32; location: Int32; bufSize: Int32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetnUniformuiv';
    
    static procedure ReadnPixels(x: Int32; y: Int32; width: Int32; height: Int32; format: UInt32; &type: UInt32; bufSize: Int32; data: pointer);
    external 'opengl32.dll' name 'glReadnPixels';
    
    static procedure TextureBarrier;
    external 'opengl32.dll' name 'glTextureBarrier';
    
    static procedure SpecializeShader(shader: UInt32; pEntryPoint: ^SByte; numSpecializationConstants: UInt32; pConstantIndex: ^UInt32; pConstantValue: ^UInt32);
    external 'opengl32.dll' name 'glSpecializeShader';
    
    static procedure MultiDrawArraysIndirectCount(mode: UInt32; indirect: pointer; drawcount: IntPtr; maxdrawcount: Int32; stride: Int32);
    external 'opengl32.dll' name 'glMultiDrawArraysIndirectCount';
    
    static procedure MultiDrawElementsIndirectCount(mode: UInt32; &type: UInt32; indirect: pointer; drawcount: IntPtr; maxdrawcount: Int32; stride: Int32);
    external 'opengl32.dll' name 'glMultiDrawElementsIndirectCount';
    
    static procedure PolygonOffsetClamp(factor: single; units: single; clamp: single);
    external 'opengl32.dll' name 'glPolygonOffsetClamp';
    
    static procedure PrimitiveBoundingBoxARB(minX: single; minY: single; minZ: single; minW: single; maxX: single; maxY: single; maxZ: single; maxW: single);
    external 'opengl32.dll' name 'glPrimitiveBoundingBoxARB';
    
    static function GetTextureHandleARB(texture: UInt32): UInt64;
    external 'opengl32.dll' name 'glGetTextureHandleARB';
    
    static function GetTextureSamplerHandleARB(texture: UInt32; sampler: UInt32): UInt64;
    external 'opengl32.dll' name 'glGetTextureSamplerHandleARB';
    
    static procedure MakeTextureHandleResidentARB(handle: UInt64);
    external 'opengl32.dll' name 'glMakeTextureHandleResidentARB';
    
    static procedure MakeTextureHandleNonResidentARB(handle: UInt64);
    external 'opengl32.dll' name 'glMakeTextureHandleNonResidentARB';
    
    static function GetImageHandleARB(texture: UInt32; level: Int32; layered: GLboolean; layer: Int32; format: UInt32): UInt64;
    external 'opengl32.dll' name 'glGetImageHandleARB';
    
    static procedure MakeImageHandleResidentARB(handle: UInt64; access: UInt32);
    external 'opengl32.dll' name 'glMakeImageHandleResidentARB';
    
    static procedure MakeImageHandleNonResidentARB(handle: UInt64);
    external 'opengl32.dll' name 'glMakeImageHandleNonResidentARB';
    
    static procedure UniformHandleui64ARB(location: Int32; value: UInt64);
    external 'opengl32.dll' name 'glUniformHandleui64ARB';
    
    static procedure UniformHandleui64vARB(location: Int32; count: Int32; value: ^UInt64);
    external 'opengl32.dll' name 'glUniformHandleui64vARB';
    
    static procedure ProgramUniformHandleui64ARB(&program: UInt32; location: Int32; value: UInt64);
    external 'opengl32.dll' name 'glProgramUniformHandleui64ARB';
    
    static procedure ProgramUniformHandleui64vARB(&program: UInt32; location: Int32; count: Int32; values: ^UInt64);
    external 'opengl32.dll' name 'glProgramUniformHandleui64vARB';
    
    static function IsTextureHandleResidentARB(handle: UInt64): GLboolean;
    external 'opengl32.dll' name 'glIsTextureHandleResidentARB';
    
    static function IsImageHandleResidentARB(handle: UInt64): GLboolean;
    external 'opengl32.dll' name 'glIsImageHandleResidentARB';
    
    static procedure VertexAttribL1ui64ARB(index: UInt32; x: UInt64EXT);
    external 'opengl32.dll' name 'glVertexAttribL1ui64ARB';
    
    static procedure VertexAttribL1ui64vARB(index: UInt32; v: ^UInt64EXT);
    external 'opengl32.dll' name 'glVertexAttribL1ui64vARB';
    
    static procedure GetVertexAttribLui64vARB(index: UInt32; pname: UInt32; &params: ^UInt64EXT);
    external 'opengl32.dll' name 'glGetVertexAttribLui64vARB';
    
    static function CreateSyncFromCLeventARB(context: ^struct_cl_context; &event: ^struct_cl_event; flags: UInt32): GLsync;
    external 'opengl32.dll' name 'glCreateSyncFromCLeventARB';
    
    static procedure DispatchComputeGroupSizeARB(num_groups_x: UInt32; num_groups_y: UInt32; num_groups_z: UInt32; group_size_x: UInt32; group_size_y: UInt32; group_size_z: UInt32);
    external 'opengl32.dll' name 'glDispatchComputeGroupSizeARB';
    
    static procedure DebugMessageControlARB(source: UInt32; &type: UInt32; severity: UInt32; count: Int32; ids: ^UInt32; enabled: GLboolean);
    external 'opengl32.dll' name 'glDebugMessageControlARB';
    
    static procedure DebugMessageInsertARB(source: UInt32; &type: UInt32; id: UInt32; severity: UInt32; length: Int32; buf: ^SByte);
    external 'opengl32.dll' name 'glDebugMessageInsertARB';
    
    static procedure DebugMessageCallbackARB(callback: GLDEBUGPROCARB; userParam: pointer);
    external 'opengl32.dll' name 'glDebugMessageCallbackARB';
    
    static function GetDebugMessageLogARB(count: UInt32; bufSize: Int32; sources: ^UInt32; types: ^UInt32; ids: ^UInt32; severities: ^UInt32; lengths: ^Int32; messageLog: ^SByte): UInt32;
    external 'opengl32.dll' name 'glGetDebugMessageLogARB';
    
    static procedure BlendEquationiARB(buf: UInt32; mode: UInt32);
    external 'opengl32.dll' name 'glBlendEquationiARB';
    
    static procedure BlendEquationSeparateiARB(buf: UInt32; modeRGB: UInt32; modeAlpha: UInt32);
    external 'opengl32.dll' name 'glBlendEquationSeparateiARB';
    
    static procedure BlendFunciARB(buf: UInt32; src: UInt32; dst: UInt32);
    external 'opengl32.dll' name 'glBlendFunciARB';
    
    static procedure BlendFuncSeparateiARB(buf: UInt32; srcRGB: UInt32; dstRGB: UInt32; srcAlpha: UInt32; dstAlpha: UInt32);
    external 'opengl32.dll' name 'glBlendFuncSeparateiARB';
    
    static procedure DrawArraysInstancedARB(mode: UInt32; first: Int32; count: Int32; primcount: Int32);
    external 'opengl32.dll' name 'glDrawArraysInstancedARB';
    
    static procedure DrawElementsInstancedARB(mode: UInt32; count: Int32; &type: UInt32; indices: pointer; primcount: Int32);
    external 'opengl32.dll' name 'glDrawElementsInstancedARB';
    
    static procedure ProgramParameteriARB(&program: UInt32; pname: UInt32; value: Int32);
    external 'opengl32.dll' name 'glProgramParameteriARB';
    
    static procedure FramebufferTextureARB(target: UInt32; attachment: UInt32; texture: UInt32; level: Int32);
    external 'opengl32.dll' name 'glFramebufferTextureARB';
    
    static procedure FramebufferTextureLayerARB(target: UInt32; attachment: UInt32; texture: UInt32; level: Int32; layer: Int32);
    external 'opengl32.dll' name 'glFramebufferTextureLayerARB';
    
    static procedure FramebufferTextureFaceARB(target: UInt32; attachment: UInt32; texture: UInt32; level: Int32; face: UInt32);
    external 'opengl32.dll' name 'glFramebufferTextureFaceARB';
    
    static procedure SpecializeShaderARB(shader: UInt32; pEntryPoint: ^SByte; numSpecializationConstants: UInt32; pConstantIndex: ^UInt32; pConstantValue: ^UInt32);
    external 'opengl32.dll' name 'glSpecializeShaderARB';
    
    static procedure Uniform1i64ARB(location: Int32; x: Int64);
    external 'opengl32.dll' name 'glUniform1i64ARB';
    
    static procedure Uniform2i64ARB(location: Int32; x: Int64; y: Int64);
    external 'opengl32.dll' name 'glUniform2i64ARB';
    
    static procedure Uniform3i64ARB(location: Int32; x: Int64; y: Int64; z: Int64);
    external 'opengl32.dll' name 'glUniform3i64ARB';
    
    static procedure Uniform4i64ARB(location: Int32; x: Int64; y: Int64; z: Int64; w: Int64);
    external 'opengl32.dll' name 'glUniform4i64ARB';
    
    static procedure Uniform1i64vARB(location: Int32; count: Int32; value: ^Int64);
    external 'opengl32.dll' name 'glUniform1i64vARB';
    
    static procedure Uniform2i64vARB(location: Int32; count: Int32; value: ^Int64);
    external 'opengl32.dll' name 'glUniform2i64vARB';
    
    static procedure Uniform3i64vARB(location: Int32; count: Int32; value: ^Int64);
    external 'opengl32.dll' name 'glUniform3i64vARB';
    
    static procedure Uniform4i64vARB(location: Int32; count: Int32; value: ^Int64);
    external 'opengl32.dll' name 'glUniform4i64vARB';
    
    static procedure Uniform1ui64ARB(location: Int32; x: UInt64);
    external 'opengl32.dll' name 'glUniform1ui64ARB';
    
    static procedure Uniform2ui64ARB(location: Int32; x: UInt64; y: UInt64);
    external 'opengl32.dll' name 'glUniform2ui64ARB';
    
    static procedure Uniform3ui64ARB(location: Int32; x: UInt64; y: UInt64; z: UInt64);
    external 'opengl32.dll' name 'glUniform3ui64ARB';
    
    static procedure Uniform4ui64ARB(location: Int32; x: UInt64; y: UInt64; z: UInt64; w: UInt64);
    external 'opengl32.dll' name 'glUniform4ui64ARB';
    
    static procedure Uniform1ui64vARB(location: Int32; count: Int32; value: ^UInt64);
    external 'opengl32.dll' name 'glUniform1ui64vARB';
    
    static procedure Uniform2ui64vARB(location: Int32; count: Int32; value: ^UInt64);
    external 'opengl32.dll' name 'glUniform2ui64vARB';
    
    static procedure Uniform3ui64vARB(location: Int32; count: Int32; value: ^UInt64);
    external 'opengl32.dll' name 'glUniform3ui64vARB';
    
    static procedure Uniform4ui64vARB(location: Int32; count: Int32; value: ^UInt64);
    external 'opengl32.dll' name 'glUniform4ui64vARB';
    
    static procedure GetUniformi64vARB(&program: UInt32; location: Int32; &params: ^Int64);
    external 'opengl32.dll' name 'glGetUniformi64vARB';
    
    static procedure GetUniformui64vARB(&program: UInt32; location: Int32; &params: ^UInt64);
    external 'opengl32.dll' name 'glGetUniformui64vARB';
    
    static procedure GetnUniformi64vARB(&program: UInt32; location: Int32; bufSize: Int32; &params: ^Int64);
    external 'opengl32.dll' name 'glGetnUniformi64vARB';
    
    static procedure GetnUniformui64vARB(&program: UInt32; location: Int32; bufSize: Int32; &params: ^UInt64);
    external 'opengl32.dll' name 'glGetnUniformui64vARB';
    
    static procedure ProgramUniform1i64ARB(&program: UInt32; location: Int32; x: Int64);
    external 'opengl32.dll' name 'glProgramUniform1i64ARB';
    
    static procedure ProgramUniform2i64ARB(&program: UInt32; location: Int32; x: Int64; y: Int64);
    external 'opengl32.dll' name 'glProgramUniform2i64ARB';
    
    static procedure ProgramUniform3i64ARB(&program: UInt32; location: Int32; x: Int64; y: Int64; z: Int64);
    external 'opengl32.dll' name 'glProgramUniform3i64ARB';
    
    static procedure ProgramUniform4i64ARB(&program: UInt32; location: Int32; x: Int64; y: Int64; z: Int64; w: Int64);
    external 'opengl32.dll' name 'glProgramUniform4i64ARB';
    
    static procedure ProgramUniform1i64vARB(&program: UInt32; location: Int32; count: Int32; value: ^Int64);
    external 'opengl32.dll' name 'glProgramUniform1i64vARB';
    
    static procedure ProgramUniform2i64vARB(&program: UInt32; location: Int32; count: Int32; value: ^Int64);
    external 'opengl32.dll' name 'glProgramUniform2i64vARB';
    
    static procedure ProgramUniform3i64vARB(&program: UInt32; location: Int32; count: Int32; value: ^Int64);
    external 'opengl32.dll' name 'glProgramUniform3i64vARB';
    
    static procedure ProgramUniform4i64vARB(&program: UInt32; location: Int32; count: Int32; value: ^Int64);
    external 'opengl32.dll' name 'glProgramUniform4i64vARB';
    
    static procedure ProgramUniform1ui64ARB(&program: UInt32; location: Int32; x: UInt64);
    external 'opengl32.dll' name 'glProgramUniform1ui64ARB';
    
    static procedure ProgramUniform2ui64ARB(&program: UInt32; location: Int32; x: UInt64; y: UInt64);
    external 'opengl32.dll' name 'glProgramUniform2ui64ARB';
    
    static procedure ProgramUniform3ui64ARB(&program: UInt32; location: Int32; x: UInt64; y: UInt64; z: UInt64);
    external 'opengl32.dll' name 'glProgramUniform3ui64ARB';
    
    static procedure ProgramUniform4ui64ARB(&program: UInt32; location: Int32; x: UInt64; y: UInt64; z: UInt64; w: UInt64);
    external 'opengl32.dll' name 'glProgramUniform4ui64ARB';
    
    static procedure ProgramUniform1ui64vARB(&program: UInt32; location: Int32; count: Int32; value: ^UInt64);
    external 'opengl32.dll' name 'glProgramUniform1ui64vARB';
    
    static procedure ProgramUniform2ui64vARB(&program: UInt32; location: Int32; count: Int32; value: ^UInt64);
    external 'opengl32.dll' name 'glProgramUniform2ui64vARB';
    
    static procedure ProgramUniform3ui64vARB(&program: UInt32; location: Int32; count: Int32; value: ^UInt64);
    external 'opengl32.dll' name 'glProgramUniform3ui64vARB';
    
    static procedure ProgramUniform4ui64vARB(&program: UInt32; location: Int32; count: Int32; value: ^UInt64);
    external 'opengl32.dll' name 'glProgramUniform4ui64vARB';
    
    static procedure MultiDrawArraysIndirectCountARB(mode: UInt32; indirect: pointer; drawcount: IntPtr; maxdrawcount: Int32; stride: Int32);
    external 'opengl32.dll' name 'glMultiDrawArraysIndirectCountARB';
    
    static procedure MultiDrawElementsIndirectCountARB(mode: UInt32; &type: UInt32; indirect: pointer; drawcount: IntPtr; maxdrawcount: Int32; stride: Int32);
    external 'opengl32.dll' name 'glMultiDrawElementsIndirectCountARB';
    
    static procedure VertexAttribDivisorARB(index: UInt32; divisor: UInt32);
    external 'opengl32.dll' name 'glVertexAttribDivisorARB';
    
    static procedure MaxShaderCompilerThreadsARB(count: UInt32);
    external 'opengl32.dll' name 'glMaxShaderCompilerThreadsARB';
    
    static function GetGraphicsResetStatusARB: UInt32;
    external 'opengl32.dll' name 'glGetGraphicsResetStatusARB';
    
    static procedure GetnTexImageARB(target: UInt32; level: Int32; format: UInt32; &type: UInt32; bufSize: Int32; img: pointer);
    external 'opengl32.dll' name 'glGetnTexImageARB';
    
    static procedure ReadnPixelsARB(x: Int32; y: Int32; width: Int32; height: Int32; format: UInt32; &type: UInt32; bufSize: Int32; data: pointer);
    external 'opengl32.dll' name 'glReadnPixelsARB';
    
    static procedure GetnCompressedTexImageARB(target: UInt32; lod: Int32; bufSize: Int32; img: pointer);
    external 'opengl32.dll' name 'glGetnCompressedTexImageARB';
    
    static procedure GetnUniformfvARB(&program: UInt32; location: Int32; bufSize: Int32; &params: ^single);
    external 'opengl32.dll' name 'glGetnUniformfvARB';
    
    static procedure GetnUniformivARB(&program: UInt32; location: Int32; bufSize: Int32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetnUniformivARB';
    
    static procedure GetnUniformuivARB(&program: UInt32; location: Int32; bufSize: Int32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetnUniformuivARB';
    
    static procedure GetnUniformdvARB(&program: UInt32; location: Int32; bufSize: Int32; &params: ^real);
    external 'opengl32.dll' name 'glGetnUniformdvARB';
    
    static procedure FramebufferSampleLocationsfvARB(target: UInt32; start: UInt32; count: Int32; v: ^single);
    external 'opengl32.dll' name 'glFramebufferSampleLocationsfvARB';
    
    static procedure NamedFramebufferSampleLocationsfvARB(framebuffer: UInt32; start: UInt32; count: Int32; v: ^single);
    external 'opengl32.dll' name 'glNamedFramebufferSampleLocationsfvARB';
    
    static procedure EvaluateDepthValuesARB;
    external 'opengl32.dll' name 'glEvaluateDepthValuesARB';
    
    static procedure MinSampleShadingARB(value: single);
    external 'opengl32.dll' name 'glMinSampleShadingARB';
    
    static procedure NamedStringARB(&type: UInt32; namelen: Int32; name: ^SByte; stringlen: Int32; string: ^SByte);
    external 'opengl32.dll' name 'glNamedStringARB';
    
    static procedure DeleteNamedStringARB(namelen: Int32; name: ^SByte);
    external 'opengl32.dll' name 'glDeleteNamedStringARB';
    
    static procedure CompileShaderIncludeARB(shader: UInt32; count: Int32; path: ^^SByteconst; length: ^Int32);
    external 'opengl32.dll' name 'glCompileShaderIncludeARB';
    
    static function IsNamedStringARB(namelen: Int32; name: ^SByte): GLboolean;
    external 'opengl32.dll' name 'glIsNamedStringARB';
    
    static procedure GetNamedStringARB(namelen: Int32; name: ^SByte; bufSize: Int32; stringlen: ^Int32; string: ^SByte);
    external 'opengl32.dll' name 'glGetNamedStringARB';
    
    static procedure GetNamedStringivARB(namelen: Int32; name: ^SByte; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetNamedStringivARB';
    
    static procedure BufferPageCommitmentARB(target: UInt32; offset: IntPtr; size: UIntPtr; commit: GLboolean);
    external 'opengl32.dll' name 'glBufferPageCommitmentARB';
    
    static procedure NamedBufferPageCommitmentEXT(buffer: UInt32; offset: IntPtr; size: UIntPtr; commit: GLboolean);
    external 'opengl32.dll' name 'glNamedBufferPageCommitmentEXT';
    
    static procedure NamedBufferPageCommitmentARB(buffer: UInt32; offset: IntPtr; size: UIntPtr; commit: GLboolean);
    external 'opengl32.dll' name 'glNamedBufferPageCommitmentARB';
    
    static procedure TexPageCommitmentARB(target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; commit: GLboolean);
    external 'opengl32.dll' name 'glTexPageCommitmentARB';
    
    static procedure TexBufferARB(target: UInt32; internalformat: UInt32; buffer: UInt32);
    external 'opengl32.dll' name 'glTexBufferARB';
    
    static procedure BlendBarrierKHR;
    external 'opengl32.dll' name 'glBlendBarrierKHR';
    
    static procedure MaxShaderCompilerThreadsKHR(count: UInt32);
    external 'opengl32.dll' name 'glMaxShaderCompilerThreadsKHR';
    
    static procedure RenderbufferStorageMultisampleAdvancedAMD(target: UInt32; samples: Int32; storageSamples: Int32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glRenderbufferStorageMultisampleAdvancedAMD';
    
    static procedure NamedRenderbufferStorageMultisampleAdvancedAMD(renderbuffer: UInt32; samples: Int32; storageSamples: Int32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glNamedRenderbufferStorageMultisampleAdvancedAMD';
    
    static procedure GetPerfMonitorGroupsAMD(numGroups: ^Int32; groupsSize: Int32; groups: ^UInt32);
    external 'opengl32.dll' name 'glGetPerfMonitorGroupsAMD';
    
    static procedure GetPerfMonitorCountersAMD(group: UInt32; numCounters: ^Int32; maxActiveCounters: ^Int32; counterSize: Int32; counters: ^UInt32);
    external 'opengl32.dll' name 'glGetPerfMonitorCountersAMD';
    
    static procedure GetPerfMonitorGroupStringAMD(group: UInt32; bufSize: Int32; length: ^Int32; groupString: ^SByte);
    external 'opengl32.dll' name 'glGetPerfMonitorGroupStringAMD';
    
    static procedure GetPerfMonitorCounterStringAMD(group: UInt32; counter: UInt32; bufSize: Int32; length: ^Int32; counterString: ^SByte);
    external 'opengl32.dll' name 'glGetPerfMonitorCounterStringAMD';
    
    static procedure GetPerfMonitorCounterInfoAMD(group: UInt32; counter: UInt32; pname: UInt32; data: pointer);
    external 'opengl32.dll' name 'glGetPerfMonitorCounterInfoAMD';
    
    static procedure GenPerfMonitorsAMD(n: Int32; monitors: ^UInt32);
    external 'opengl32.dll' name 'glGenPerfMonitorsAMD';
    
    static procedure DeletePerfMonitorsAMD(n: Int32; monitors: ^UInt32);
    external 'opengl32.dll' name 'glDeletePerfMonitorsAMD';
    
    static procedure SelectPerfMonitorCountersAMD(monitor: UInt32; enable: GLboolean; group: UInt32; numCounters: Int32; counterList: ^UInt32);
    external 'opengl32.dll' name 'glSelectPerfMonitorCountersAMD';
    
    static procedure BeginPerfMonitorAMD(monitor: UInt32);
    external 'opengl32.dll' name 'glBeginPerfMonitorAMD';
    
    static procedure EndPerfMonitorAMD(monitor: UInt32);
    external 'opengl32.dll' name 'glEndPerfMonitorAMD';
    
    static procedure GetPerfMonitorCounterDataAMD(monitor: UInt32; pname: UInt32; dataSize: Int32; data: ^UInt32; bytesWritten: ^Int32);
    external 'opengl32.dll' name 'glGetPerfMonitorCounterDataAMD';
    
    static procedure EGLImageTargetTexStorageEXT(target: UInt32; image: GLeglImageOES; attrib_list: ^Int32);
    external 'opengl32.dll' name 'glEGLImageTargetTexStorageEXT';
    
    static procedure EGLImageTargetTextureStorageEXT(texture: UInt32; image: GLeglImageOES; attrib_list: ^Int32);
    external 'opengl32.dll' name 'glEGLImageTargetTextureStorageEXT';
    
    static procedure LabelObjectEXT(&type: UInt32; object: UInt32; length: Int32; &label: ^SByte);
    external 'opengl32.dll' name 'glLabelObjectEXT';
    
    static procedure GetObjectLabelEXT(&type: UInt32; object: UInt32; bufSize: Int32; length: ^Int32; &label: ^SByte);
    external 'opengl32.dll' name 'glGetObjectLabelEXT';
    
    static procedure InsertEventMarkerEXT(length: Int32; marker: ^SByte);
    external 'opengl32.dll' name 'glInsertEventMarkerEXT';
    
    static procedure PushGroupMarkerEXT(length: Int32; marker: ^SByte);
    external 'opengl32.dll' name 'glPushGroupMarkerEXT';
    
    static procedure PopGroupMarkerEXT;
    external 'opengl32.dll' name 'glPopGroupMarkerEXT';
    
    static procedure MatrixLoadfEXT(mode: UInt32; m: ^single);
    external 'opengl32.dll' name 'glMatrixLoadfEXT';
    
    static procedure MatrixLoaddEXT(mode: UInt32; m: ^real);
    external 'opengl32.dll' name 'glMatrixLoaddEXT';
    
    static procedure MatrixMultfEXT(mode: UInt32; m: ^single);
    external 'opengl32.dll' name 'glMatrixMultfEXT';
    
    static procedure MatrixMultdEXT(mode: UInt32; m: ^real);
    external 'opengl32.dll' name 'glMatrixMultdEXT';
    
    static procedure MatrixLoadIdentityEXT(mode: UInt32);
    external 'opengl32.dll' name 'glMatrixLoadIdentityEXT';
    
    static procedure MatrixRotatefEXT(mode: UInt32; angle: single; x: single; y: single; z: single);
    external 'opengl32.dll' name 'glMatrixRotatefEXT';
    
    static procedure MatrixRotatedEXT(mode: UInt32; angle: real; x: real; y: real; z: real);
    external 'opengl32.dll' name 'glMatrixRotatedEXT';
    
    static procedure MatrixScalefEXT(mode: UInt32; x: single; y: single; z: single);
    external 'opengl32.dll' name 'glMatrixScalefEXT';
    
    static procedure MatrixScaledEXT(mode: UInt32; x: real; y: real; z: real);
    external 'opengl32.dll' name 'glMatrixScaledEXT';
    
    static procedure MatrixTranslatefEXT(mode: UInt32; x: single; y: single; z: single);
    external 'opengl32.dll' name 'glMatrixTranslatefEXT';
    
    static procedure MatrixTranslatedEXT(mode: UInt32; x: real; y: real; z: real);
    external 'opengl32.dll' name 'glMatrixTranslatedEXT';
    
    static procedure MatrixFrustumEXT(mode: UInt32; left: real; right: real; bottom: real; top: real; zNear: real; zFar: real);
    external 'opengl32.dll' name 'glMatrixFrustumEXT';
    
    static procedure MatrixOrthoEXT(mode: UInt32; left: real; right: real; bottom: real; top: real; zNear: real; zFar: real);
    external 'opengl32.dll' name 'glMatrixOrthoEXT';
    
    static procedure MatrixPopEXT(mode: UInt32);
    external 'opengl32.dll' name 'glMatrixPopEXT';
    
    static procedure MatrixPushEXT(mode: UInt32);
    external 'opengl32.dll' name 'glMatrixPushEXT';
    
    static procedure ClientAttribDefaultEXT(mask: UInt32);
    external 'opengl32.dll' name 'glClientAttribDefaultEXT';
    
    static procedure PushClientAttribDefaultEXT(mask: UInt32);
    external 'opengl32.dll' name 'glPushClientAttribDefaultEXT';
    
    static procedure TextureParameterfEXT(texture: UInt32; target: UInt32; pname: UInt32; param: single);
    external 'opengl32.dll' name 'glTextureParameterfEXT';
    
    static procedure TextureParameterfvEXT(texture: UInt32; target: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glTextureParameterfvEXT';
    
    static procedure TextureParameteriEXT(texture: UInt32; target: UInt32; pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glTextureParameteriEXT';
    
    static procedure TextureParameterivEXT(texture: UInt32; target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glTextureParameterivEXT';
    
    static procedure TextureImage1DEXT(texture: UInt32; target: UInt32; level: Int32; internalformat: Int32; width: Int32; border: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTextureImage1DEXT';
    
    static procedure TextureImage2DEXT(texture: UInt32; target: UInt32; level: Int32; internalformat: Int32; width: Int32; height: Int32; border: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTextureImage2DEXT';
    
    static procedure TextureSubImage1DEXT(texture: UInt32; target: UInt32; level: Int32; xoffset: Int32; width: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTextureSubImage1DEXT';
    
    static procedure TextureSubImage2DEXT(texture: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; width: Int32; height: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTextureSubImage2DEXT';
    
    static procedure CopyTextureImage1DEXT(texture: UInt32; target: UInt32; level: Int32; internalformat: UInt32; x: Int32; y: Int32; width: Int32; border: Int32);
    external 'opengl32.dll' name 'glCopyTextureImage1DEXT';
    
    static procedure CopyTextureImage2DEXT(texture: UInt32; target: UInt32; level: Int32; internalformat: UInt32; x: Int32; y: Int32; width: Int32; height: Int32; border: Int32);
    external 'opengl32.dll' name 'glCopyTextureImage2DEXT';
    
    static procedure CopyTextureSubImage1DEXT(texture: UInt32; target: UInt32; level: Int32; xoffset: Int32; x: Int32; y: Int32; width: Int32);
    external 'opengl32.dll' name 'glCopyTextureSubImage1DEXT';
    
    static procedure CopyTextureSubImage2DEXT(texture: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glCopyTextureSubImage2DEXT';
    
    static procedure GetTextureImageEXT(texture: UInt32; target: UInt32; level: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glGetTextureImageEXT';
    
    static procedure GetTextureParameterfvEXT(texture: UInt32; target: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetTextureParameterfvEXT';
    
    static procedure GetTextureParameterivEXT(texture: UInt32; target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetTextureParameterivEXT';
    
    static procedure GetTextureLevelParameterfvEXT(texture: UInt32; target: UInt32; level: Int32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetTextureLevelParameterfvEXT';
    
    static procedure GetTextureLevelParameterivEXT(texture: UInt32; target: UInt32; level: Int32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetTextureLevelParameterivEXT';
    
    static procedure TextureImage3DEXT(texture: UInt32; target: UInt32; level: Int32; internalformat: Int32; width: Int32; height: Int32; depth: Int32; border: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTextureImage3DEXT';
    
    static procedure TextureSubImage3DEXT(texture: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glTextureSubImage3DEXT';
    
    static procedure CopyTextureSubImage3DEXT(texture: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glCopyTextureSubImage3DEXT';
    
    static procedure BindMultiTextureEXT(texunit: UInt32; target: UInt32; texture: UInt32);
    external 'opengl32.dll' name 'glBindMultiTextureEXT';
    
    static procedure MultiTexCoordPointerEXT(texunit: UInt32; size: Int32; &type: UInt32; stride: Int32; pointer: pointer);
    external 'opengl32.dll' name 'glMultiTexCoordPointerEXT';
    
    static procedure MultiTexEnvfEXT(texunit: UInt32; target: UInt32; pname: UInt32; param: single);
    external 'opengl32.dll' name 'glMultiTexEnvfEXT';
    
    static procedure MultiTexEnvfvEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glMultiTexEnvfvEXT';
    
    static procedure MultiTexEnviEXT(texunit: UInt32; target: UInt32; pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glMultiTexEnviEXT';
    
    static procedure MultiTexEnvivEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glMultiTexEnvivEXT';
    
    static procedure MultiTexGendEXT(texunit: UInt32; coord: UInt32; pname: UInt32; param: real);
    external 'opengl32.dll' name 'glMultiTexGendEXT';
    
    static procedure MultiTexGendvEXT(texunit: UInt32; coord: UInt32; pname: UInt32; &params: ^real);
    external 'opengl32.dll' name 'glMultiTexGendvEXT';
    
    static procedure MultiTexGenfEXT(texunit: UInt32; coord: UInt32; pname: UInt32; param: single);
    external 'opengl32.dll' name 'glMultiTexGenfEXT';
    
    static procedure MultiTexGenfvEXT(texunit: UInt32; coord: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glMultiTexGenfvEXT';
    
    static procedure MultiTexGeniEXT(texunit: UInt32; coord: UInt32; pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glMultiTexGeniEXT';
    
    static procedure MultiTexGenivEXT(texunit: UInt32; coord: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glMultiTexGenivEXT';
    
    static procedure GetMultiTexEnvfvEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetMultiTexEnvfvEXT';
    
    static procedure GetMultiTexEnvivEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetMultiTexEnvivEXT';
    
    static procedure GetMultiTexGendvEXT(texunit: UInt32; coord: UInt32; pname: UInt32; &params: ^real);
    external 'opengl32.dll' name 'glGetMultiTexGendvEXT';
    
    static procedure GetMultiTexGenfvEXT(texunit: UInt32; coord: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetMultiTexGenfvEXT';
    
    static procedure GetMultiTexGenivEXT(texunit: UInt32; coord: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetMultiTexGenivEXT';
    
    static procedure MultiTexParameteriEXT(texunit: UInt32; target: UInt32; pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glMultiTexParameteriEXT';
    
    static procedure MultiTexParameterivEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glMultiTexParameterivEXT';
    
    static procedure MultiTexParameterfEXT(texunit: UInt32; target: UInt32; pname: UInt32; param: single);
    external 'opengl32.dll' name 'glMultiTexParameterfEXT';
    
    static procedure MultiTexParameterfvEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glMultiTexParameterfvEXT';
    
    static procedure MultiTexImage1DEXT(texunit: UInt32; target: UInt32; level: Int32; internalformat: Int32; width: Int32; border: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glMultiTexImage1DEXT';
    
    static procedure MultiTexImage2DEXT(texunit: UInt32; target: UInt32; level: Int32; internalformat: Int32; width: Int32; height: Int32; border: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glMultiTexImage2DEXT';
    
    static procedure MultiTexSubImage1DEXT(texunit: UInt32; target: UInt32; level: Int32; xoffset: Int32; width: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glMultiTexSubImage1DEXT';
    
    static procedure MultiTexSubImage2DEXT(texunit: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; width: Int32; height: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glMultiTexSubImage2DEXT';
    
    static procedure CopyMultiTexImage1DEXT(texunit: UInt32; target: UInt32; level: Int32; internalformat: UInt32; x: Int32; y: Int32; width: Int32; border: Int32);
    external 'opengl32.dll' name 'glCopyMultiTexImage1DEXT';
    
    static procedure CopyMultiTexImage2DEXT(texunit: UInt32; target: UInt32; level: Int32; internalformat: UInt32; x: Int32; y: Int32; width: Int32; height: Int32; border: Int32);
    external 'opengl32.dll' name 'glCopyMultiTexImage2DEXT';
    
    static procedure CopyMultiTexSubImage1DEXT(texunit: UInt32; target: UInt32; level: Int32; xoffset: Int32; x: Int32; y: Int32; width: Int32);
    external 'opengl32.dll' name 'glCopyMultiTexSubImage1DEXT';
    
    static procedure CopyMultiTexSubImage2DEXT(texunit: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glCopyMultiTexSubImage2DEXT';
    
    static procedure GetMultiTexImageEXT(texunit: UInt32; target: UInt32; level: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glGetMultiTexImageEXT';
    
    static procedure GetMultiTexParameterfvEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetMultiTexParameterfvEXT';
    
    static procedure GetMultiTexParameterivEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetMultiTexParameterivEXT';
    
    static procedure GetMultiTexLevelParameterfvEXT(texunit: UInt32; target: UInt32; level: Int32; pname: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetMultiTexLevelParameterfvEXT';
    
    static procedure GetMultiTexLevelParameterivEXT(texunit: UInt32; target: UInt32; level: Int32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetMultiTexLevelParameterivEXT';
    
    static procedure MultiTexImage3DEXT(texunit: UInt32; target: UInt32; level: Int32; internalformat: Int32; width: Int32; height: Int32; depth: Int32; border: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glMultiTexImage3DEXT';
    
    static procedure MultiTexSubImage3DEXT(texunit: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; format: UInt32; &type: UInt32; pixels: pointer);
    external 'opengl32.dll' name 'glMultiTexSubImage3DEXT';
    
    static procedure CopyMultiTexSubImage3DEXT(texunit: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glCopyMultiTexSubImage3DEXT';
    
    static procedure EnableClientStateIndexedEXT(&array: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glEnableClientStateIndexedEXT';
    
    static procedure DisableClientStateIndexedEXT(&array: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glDisableClientStateIndexedEXT';
    
    static procedure GetFloatIndexedvEXT(target: UInt32; index: UInt32; data: ^single);
    external 'opengl32.dll' name 'glGetFloatIndexedvEXT';
    
    static procedure GetDoubleIndexedvEXT(target: UInt32; index: UInt32; data: ^real);
    external 'opengl32.dll' name 'glGetDoubleIndexedvEXT';
    
    static procedure GetPointerIndexedvEXT(target: UInt32; index: UInt32; data: ^IntPtr);
    external 'opengl32.dll' name 'glGetPointerIndexedvEXT';
    
    static procedure EnableIndexedEXT(target: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glEnableIndexedEXT';
    
    static procedure DisableIndexedEXT(target: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glDisableIndexedEXT';
    
    static function IsEnabledIndexedEXT(target: UInt32; index: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsEnabledIndexedEXT';
    
    static procedure GetIntegerIndexedvEXT(target: UInt32; index: UInt32; data: ^Int32);
    external 'opengl32.dll' name 'glGetIntegerIndexedvEXT';
    
    static procedure GetBooleanIndexedvEXT(target: UInt32; index: UInt32; data: ^GLboolean);
    external 'opengl32.dll' name 'glGetBooleanIndexedvEXT';
    
    static procedure CompressedTextureImage3DEXT(texture: UInt32; target: UInt32; level: Int32; internalformat: UInt32; width: Int32; height: Int32; depth: Int32; border: Int32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedTextureImage3DEXT';
    
    static procedure CompressedTextureImage2DEXT(texture: UInt32; target: UInt32; level: Int32; internalformat: UInt32; width: Int32; height: Int32; border: Int32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedTextureImage2DEXT';
    
    static procedure CompressedTextureImage1DEXT(texture: UInt32; target: UInt32; level: Int32; internalformat: UInt32; width: Int32; border: Int32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedTextureImage1DEXT';
    
    static procedure CompressedTextureSubImage3DEXT(texture: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; format: UInt32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedTextureSubImage3DEXT';
    
    static procedure CompressedTextureSubImage2DEXT(texture: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; width: Int32; height: Int32; format: UInt32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedTextureSubImage2DEXT';
    
    static procedure CompressedTextureSubImage1DEXT(texture: UInt32; target: UInt32; level: Int32; xoffset: Int32; width: Int32; format: UInt32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedTextureSubImage1DEXT';
    
    static procedure GetCompressedTextureImageEXT(texture: UInt32; target: UInt32; lod: Int32; img: pointer);
    external 'opengl32.dll' name 'glGetCompressedTextureImageEXT';
    
    static procedure CompressedMultiTexImage3DEXT(texunit: UInt32; target: UInt32; level: Int32; internalformat: UInt32; width: Int32; height: Int32; depth: Int32; border: Int32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedMultiTexImage3DEXT';
    
    static procedure CompressedMultiTexImage2DEXT(texunit: UInt32; target: UInt32; level: Int32; internalformat: UInt32; width: Int32; height: Int32; border: Int32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedMultiTexImage2DEXT';
    
    static procedure CompressedMultiTexImage1DEXT(texunit: UInt32; target: UInt32; level: Int32; internalformat: UInt32; width: Int32; border: Int32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedMultiTexImage1DEXT';
    
    static procedure CompressedMultiTexSubImage3DEXT(texunit: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; format: UInt32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedMultiTexSubImage3DEXT';
    
    static procedure CompressedMultiTexSubImage2DEXT(texunit: UInt32; target: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; width: Int32; height: Int32; format: UInt32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedMultiTexSubImage2DEXT';
    
    static procedure CompressedMultiTexSubImage1DEXT(texunit: UInt32; target: UInt32; level: Int32; xoffset: Int32; width: Int32; format: UInt32; imageSize: Int32; bits: pointer);
    external 'opengl32.dll' name 'glCompressedMultiTexSubImage1DEXT';
    
    static procedure GetCompressedMultiTexImageEXT(texunit: UInt32; target: UInt32; lod: Int32; img: pointer);
    external 'opengl32.dll' name 'glGetCompressedMultiTexImageEXT';
    
    static procedure MatrixLoadTransposefEXT(mode: UInt32; m: ^single);
    external 'opengl32.dll' name 'glMatrixLoadTransposefEXT';
    
    static procedure MatrixLoadTransposedEXT(mode: UInt32; m: ^real);
    external 'opengl32.dll' name 'glMatrixLoadTransposedEXT';
    
    static procedure MatrixMultTransposefEXT(mode: UInt32; m: ^single);
    external 'opengl32.dll' name 'glMatrixMultTransposefEXT';
    
    static procedure MatrixMultTransposedEXT(mode: UInt32; m: ^real);
    external 'opengl32.dll' name 'glMatrixMultTransposedEXT';
    
    static procedure NamedBufferDataEXT(buffer: UInt32; size: UIntPtr; data: pointer; usage: UInt32);
    external 'opengl32.dll' name 'glNamedBufferDataEXT';
    
    static procedure NamedBufferSubDataEXT(buffer: UInt32; offset: IntPtr; size: UIntPtr; data: pointer);
    external 'opengl32.dll' name 'glNamedBufferSubDataEXT';
    
    static function MapNamedBufferEXT(buffer: UInt32; access: UInt32): pointer;
    external 'opengl32.dll' name 'glMapNamedBufferEXT';
    
    static function UnmapNamedBufferEXT(buffer: UInt32): GLboolean;
    external 'opengl32.dll' name 'glUnmapNamedBufferEXT';
    
    static procedure GetNamedBufferParameterivEXT(buffer: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetNamedBufferParameterivEXT';
    
    static procedure GetNamedBufferPointervEXT(buffer: UInt32; pname: UInt32; &params: ^IntPtr);
    external 'opengl32.dll' name 'glGetNamedBufferPointervEXT';
    
    static procedure GetNamedBufferSubDataEXT(buffer: UInt32; offset: IntPtr; size: UIntPtr; data: pointer);
    external 'opengl32.dll' name 'glGetNamedBufferSubDataEXT';
    
    static procedure ProgramUniform1fEXT(&program: UInt32; location: Int32; v0: single);
    external 'opengl32.dll' name 'glProgramUniform1fEXT';
    
    static procedure ProgramUniform2fEXT(&program: UInt32; location: Int32; v0: single; v1: single);
    external 'opengl32.dll' name 'glProgramUniform2fEXT';
    
    static procedure ProgramUniform3fEXT(&program: UInt32; location: Int32; v0: single; v1: single; v2: single);
    external 'opengl32.dll' name 'glProgramUniform3fEXT';
    
    static procedure ProgramUniform4fEXT(&program: UInt32; location: Int32; v0: single; v1: single; v2: single; v3: single);
    external 'opengl32.dll' name 'glProgramUniform4fEXT';
    
    static procedure ProgramUniform1iEXT(&program: UInt32; location: Int32; v0: Int32);
    external 'opengl32.dll' name 'glProgramUniform1iEXT';
    
    static procedure ProgramUniform2iEXT(&program: UInt32; location: Int32; v0: Int32; v1: Int32);
    external 'opengl32.dll' name 'glProgramUniform2iEXT';
    
    static procedure ProgramUniform3iEXT(&program: UInt32; location: Int32; v0: Int32; v1: Int32; v2: Int32);
    external 'opengl32.dll' name 'glProgramUniform3iEXT';
    
    static procedure ProgramUniform4iEXT(&program: UInt32; location: Int32; v0: Int32; v1: Int32; v2: Int32; v3: Int32);
    external 'opengl32.dll' name 'glProgramUniform4iEXT';
    
    static procedure ProgramUniform1fvEXT(&program: UInt32; location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glProgramUniform1fvEXT';
    
    static procedure ProgramUniform2fvEXT(&program: UInt32; location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glProgramUniform2fvEXT';
    
    static procedure ProgramUniform3fvEXT(&program: UInt32; location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glProgramUniform3fvEXT';
    
    static procedure ProgramUniform4fvEXT(&program: UInt32; location: Int32; count: Int32; value: ^single);
    external 'opengl32.dll' name 'glProgramUniform4fvEXT';
    
    static procedure ProgramUniform1ivEXT(&program: UInt32; location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glProgramUniform1ivEXT';
    
    static procedure ProgramUniform2ivEXT(&program: UInt32; location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glProgramUniform2ivEXT';
    
    static procedure ProgramUniform3ivEXT(&program: UInt32; location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glProgramUniform3ivEXT';
    
    static procedure ProgramUniform4ivEXT(&program: UInt32; location: Int32; count: Int32; value: ^Int32);
    external 'opengl32.dll' name 'glProgramUniform4ivEXT';
    
    static procedure ProgramUniformMatrix2fvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix2fvEXT';
    
    static procedure ProgramUniformMatrix3fvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix3fvEXT';
    
    static procedure ProgramUniformMatrix4fvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix4fvEXT';
    
    static procedure ProgramUniformMatrix2x3fvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix2x3fvEXT';
    
    static procedure ProgramUniformMatrix3x2fvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix3x2fvEXT';
    
    static procedure ProgramUniformMatrix2x4fvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix2x4fvEXT';
    
    static procedure ProgramUniformMatrix4x2fvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix4x2fvEXT';
    
    static procedure ProgramUniformMatrix3x4fvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix3x4fvEXT';
    
    static procedure ProgramUniformMatrix4x3fvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^single);
    external 'opengl32.dll' name 'glProgramUniformMatrix4x3fvEXT';
    
    static procedure TextureBufferEXT(texture: UInt32; target: UInt32; internalformat: UInt32; buffer: UInt32);
    external 'opengl32.dll' name 'glTextureBufferEXT';
    
    static procedure MultiTexBufferEXT(texunit: UInt32; target: UInt32; internalformat: UInt32; buffer: UInt32);
    external 'opengl32.dll' name 'glMultiTexBufferEXT';
    
    static procedure TextureParameterIivEXT(texture: UInt32; target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glTextureParameterIivEXT';
    
    static procedure TextureParameterIuivEXT(texture: UInt32; target: UInt32; pname: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glTextureParameterIuivEXT';
    
    static procedure GetTextureParameterIivEXT(texture: UInt32; target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetTextureParameterIivEXT';
    
    static procedure GetTextureParameterIuivEXT(texture: UInt32; target: UInt32; pname: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetTextureParameterIuivEXT';
    
    static procedure MultiTexParameterIivEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glMultiTexParameterIivEXT';
    
    static procedure MultiTexParameterIuivEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glMultiTexParameterIuivEXT';
    
    static procedure GetMultiTexParameterIivEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetMultiTexParameterIivEXT';
    
    static procedure GetMultiTexParameterIuivEXT(texunit: UInt32; target: UInt32; pname: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetMultiTexParameterIuivEXT';
    
    static procedure ProgramUniform1uiEXT(&program: UInt32; location: Int32; v0: UInt32);
    external 'opengl32.dll' name 'glProgramUniform1uiEXT';
    
    static procedure ProgramUniform2uiEXT(&program: UInt32; location: Int32; v0: UInt32; v1: UInt32);
    external 'opengl32.dll' name 'glProgramUniform2uiEXT';
    
    static procedure ProgramUniform3uiEXT(&program: UInt32; location: Int32; v0: UInt32; v1: UInt32; v2: UInt32);
    external 'opengl32.dll' name 'glProgramUniform3uiEXT';
    
    static procedure ProgramUniform4uiEXT(&program: UInt32; location: Int32; v0: UInt32; v1: UInt32; v2: UInt32; v3: UInt32);
    external 'opengl32.dll' name 'glProgramUniform4uiEXT';
    
    static procedure ProgramUniform1uivEXT(&program: UInt32; location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glProgramUniform1uivEXT';
    
    static procedure ProgramUniform2uivEXT(&program: UInt32; location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glProgramUniform2uivEXT';
    
    static procedure ProgramUniform3uivEXT(&program: UInt32; location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glProgramUniform3uivEXT';
    
    static procedure ProgramUniform4uivEXT(&program: UInt32; location: Int32; count: Int32; value: ^UInt32);
    external 'opengl32.dll' name 'glProgramUniform4uivEXT';
    
    static procedure NamedProgramLocalParameters4fvEXT(&program: UInt32; target: UInt32; index: UInt32; count: Int32; &params: ^single);
    external 'opengl32.dll' name 'glNamedProgramLocalParameters4fvEXT';
    
    static procedure NamedProgramLocalParameterI4iEXT(&program: UInt32; target: UInt32; index: UInt32; x: Int32; y: Int32; z: Int32; w: Int32);
    external 'opengl32.dll' name 'glNamedProgramLocalParameterI4iEXT';
    
    static procedure NamedProgramLocalParameterI4ivEXT(&program: UInt32; target: UInt32; index: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glNamedProgramLocalParameterI4ivEXT';
    
    static procedure NamedProgramLocalParametersI4ivEXT(&program: UInt32; target: UInt32; index: UInt32; count: Int32; &params: ^Int32);
    external 'opengl32.dll' name 'glNamedProgramLocalParametersI4ivEXT';
    
    static procedure NamedProgramLocalParameterI4uiEXT(&program: UInt32; target: UInt32; index: UInt32; x: UInt32; y: UInt32; z: UInt32; w: UInt32);
    external 'opengl32.dll' name 'glNamedProgramLocalParameterI4uiEXT';
    
    static procedure NamedProgramLocalParameterI4uivEXT(&program: UInt32; target: UInt32; index: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glNamedProgramLocalParameterI4uivEXT';
    
    static procedure NamedProgramLocalParametersI4uivEXT(&program: UInt32; target: UInt32; index: UInt32; count: Int32; &params: ^UInt32);
    external 'opengl32.dll' name 'glNamedProgramLocalParametersI4uivEXT';
    
    static procedure GetNamedProgramLocalParameterIivEXT(&program: UInt32; target: UInt32; index: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetNamedProgramLocalParameterIivEXT';
    
    static procedure GetNamedProgramLocalParameterIuivEXT(&program: UInt32; target: UInt32; index: UInt32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetNamedProgramLocalParameterIuivEXT';
    
    static procedure EnableClientStateiEXT(&array: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glEnableClientStateiEXT';
    
    static procedure DisableClientStateiEXT(&array: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glDisableClientStateiEXT';
    
    static procedure GetFloati_vEXT(pname: UInt32; index: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetFloati_vEXT';
    
    static procedure GetDoublei_vEXT(pname: UInt32; index: UInt32; &params: ^real);
    external 'opengl32.dll' name 'glGetDoublei_vEXT';
    
    static procedure GetPointeri_vEXT(pname: UInt32; index: UInt32; &params: ^IntPtr);
    external 'opengl32.dll' name 'glGetPointeri_vEXT';
    
    static procedure NamedProgramStringEXT(&program: UInt32; target: UInt32; format: UInt32; len: Int32; string: pointer);
    external 'opengl32.dll' name 'glNamedProgramStringEXT';
    
    static procedure NamedProgramLocalParameter4dEXT(&program: UInt32; target: UInt32; index: UInt32; x: real; y: real; z: real; w: real);
    external 'opengl32.dll' name 'glNamedProgramLocalParameter4dEXT';
    
    static procedure NamedProgramLocalParameter4dvEXT(&program: UInt32; target: UInt32; index: UInt32; &params: ^real);
    external 'opengl32.dll' name 'glNamedProgramLocalParameter4dvEXT';
    
    static procedure NamedProgramLocalParameter4fEXT(&program: UInt32; target: UInt32; index: UInt32; x: single; y: single; z: single; w: single);
    external 'opengl32.dll' name 'glNamedProgramLocalParameter4fEXT';
    
    static procedure NamedProgramLocalParameter4fvEXT(&program: UInt32; target: UInt32; index: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glNamedProgramLocalParameter4fvEXT';
    
    static procedure GetNamedProgramLocalParameterdvEXT(&program: UInt32; target: UInt32; index: UInt32; &params: ^real);
    external 'opengl32.dll' name 'glGetNamedProgramLocalParameterdvEXT';
    
    static procedure GetNamedProgramLocalParameterfvEXT(&program: UInt32; target: UInt32; index: UInt32; &params: ^single);
    external 'opengl32.dll' name 'glGetNamedProgramLocalParameterfvEXT';
    
    static procedure GetNamedProgramivEXT(&program: UInt32; target: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetNamedProgramivEXT';
    
    static procedure GetNamedProgramStringEXT(&program: UInt32; target: UInt32; pname: UInt32; string: pointer);
    external 'opengl32.dll' name 'glGetNamedProgramStringEXT';
    
    static procedure NamedRenderbufferStorageEXT(renderbuffer: UInt32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glNamedRenderbufferStorageEXT';
    
    static procedure GetNamedRenderbufferParameterivEXT(renderbuffer: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetNamedRenderbufferParameterivEXT';
    
    static procedure NamedRenderbufferStorageMultisampleEXT(renderbuffer: UInt32; samples: Int32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glNamedRenderbufferStorageMultisampleEXT';
    
    static procedure NamedRenderbufferStorageMultisampleCoverageEXT(renderbuffer: UInt32; coverageSamples: Int32; colorSamples: Int32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glNamedRenderbufferStorageMultisampleCoverageEXT';
    
    static function CheckNamedFramebufferStatusEXT(framebuffer: UInt32; target: UInt32): UInt32;
    external 'opengl32.dll' name 'glCheckNamedFramebufferStatusEXT';
    
    static procedure NamedFramebufferTexture1DEXT(framebuffer: UInt32; attachment: UInt32; textarget: UInt32; texture: UInt32; level: Int32);
    external 'opengl32.dll' name 'glNamedFramebufferTexture1DEXT';
    
    static procedure NamedFramebufferTexture2DEXT(framebuffer: UInt32; attachment: UInt32; textarget: UInt32; texture: UInt32; level: Int32);
    external 'opengl32.dll' name 'glNamedFramebufferTexture2DEXT';
    
    static procedure NamedFramebufferTexture3DEXT(framebuffer: UInt32; attachment: UInt32; textarget: UInt32; texture: UInt32; level: Int32; zoffset: Int32);
    external 'opengl32.dll' name 'glNamedFramebufferTexture3DEXT';
    
    static procedure NamedFramebufferRenderbufferEXT(framebuffer: UInt32; attachment: UInt32; renderbuffertarget: UInt32; renderbuffer: UInt32);
    external 'opengl32.dll' name 'glNamedFramebufferRenderbufferEXT';
    
    static procedure GetNamedFramebufferAttachmentParameterivEXT(framebuffer: UInt32; attachment: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetNamedFramebufferAttachmentParameterivEXT';
    
    static procedure GenerateTextureMipmapEXT(texture: UInt32; target: UInt32);
    external 'opengl32.dll' name 'glGenerateTextureMipmapEXT';
    
    static procedure GenerateMultiTexMipmapEXT(texunit: UInt32; target: UInt32);
    external 'opengl32.dll' name 'glGenerateMultiTexMipmapEXT';
    
    static procedure FramebufferDrawBufferEXT(framebuffer: UInt32; mode: UInt32);
    external 'opengl32.dll' name 'glFramebufferDrawBufferEXT';
    
    static procedure FramebufferDrawBuffersEXT(framebuffer: UInt32; n: Int32; bufs: ^UInt32);
    external 'opengl32.dll' name 'glFramebufferDrawBuffersEXT';
    
    static procedure FramebufferReadBufferEXT(framebuffer: UInt32; mode: UInt32);
    external 'opengl32.dll' name 'glFramebufferReadBufferEXT';
    
    static procedure GetFramebufferParameterivEXT(framebuffer: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetFramebufferParameterivEXT';
    
    static procedure NamedCopyBufferSubDataEXT(readBuffer: UInt32; writeBuffer: UInt32; readOffset: IntPtr; writeOffset: IntPtr; size: UIntPtr);
    external 'opengl32.dll' name 'glNamedCopyBufferSubDataEXT';
    
    static procedure NamedFramebufferTextureEXT(framebuffer: UInt32; attachment: UInt32; texture: UInt32; level: Int32);
    external 'opengl32.dll' name 'glNamedFramebufferTextureEXT';
    
    static procedure NamedFramebufferTextureLayerEXT(framebuffer: UInt32; attachment: UInt32; texture: UInt32; level: Int32; layer: Int32);
    external 'opengl32.dll' name 'glNamedFramebufferTextureLayerEXT';
    
    static procedure NamedFramebufferTextureFaceEXT(framebuffer: UInt32; attachment: UInt32; texture: UInt32; level: Int32; face: UInt32);
    external 'opengl32.dll' name 'glNamedFramebufferTextureFaceEXT';
    
    static procedure TextureRenderbufferEXT(texture: UInt32; target: UInt32; renderbuffer: UInt32);
    external 'opengl32.dll' name 'glTextureRenderbufferEXT';
    
    static procedure MultiTexRenderbufferEXT(texunit: UInt32; target: UInt32; renderbuffer: UInt32);
    external 'opengl32.dll' name 'glMultiTexRenderbufferEXT';
    
    static procedure VertexArrayVertexOffsetEXT(vaobj: UInt32; buffer: UInt32; size: Int32; &type: UInt32; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArrayVertexOffsetEXT';
    
    static procedure VertexArrayColorOffsetEXT(vaobj: UInt32; buffer: UInt32; size: Int32; &type: UInt32; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArrayColorOffsetEXT';
    
    static procedure VertexArrayEdgeFlagOffsetEXT(vaobj: UInt32; buffer: UInt32; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArrayEdgeFlagOffsetEXT';
    
    static procedure VertexArrayIndexOffsetEXT(vaobj: UInt32; buffer: UInt32; &type: UInt32; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArrayIndexOffsetEXT';
    
    static procedure VertexArrayNormalOffsetEXT(vaobj: UInt32; buffer: UInt32; &type: UInt32; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArrayNormalOffsetEXT';
    
    static procedure VertexArrayTexCoordOffsetEXT(vaobj: UInt32; buffer: UInt32; size: Int32; &type: UInt32; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArrayTexCoordOffsetEXT';
    
    static procedure VertexArrayMultiTexCoordOffsetEXT(vaobj: UInt32; buffer: UInt32; texunit: UInt32; size: Int32; &type: UInt32; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArrayMultiTexCoordOffsetEXT';
    
    static procedure VertexArrayFogCoordOffsetEXT(vaobj: UInt32; buffer: UInt32; &type: UInt32; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArrayFogCoordOffsetEXT';
    
    static procedure VertexArraySecondaryColorOffsetEXT(vaobj: UInt32; buffer: UInt32; size: Int32; &type: UInt32; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArraySecondaryColorOffsetEXT';
    
    static procedure VertexArrayVertexAttribOffsetEXT(vaobj: UInt32; buffer: UInt32; index: UInt32; size: Int32; &type: UInt32; normalized: GLboolean; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArrayVertexAttribOffsetEXT';
    
    static procedure VertexArrayVertexAttribIOffsetEXT(vaobj: UInt32; buffer: UInt32; index: UInt32; size: Int32; &type: UInt32; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArrayVertexAttribIOffsetEXT';
    
    static procedure EnableVertexArrayEXT(vaobj: UInt32; &array: UInt32);
    external 'opengl32.dll' name 'glEnableVertexArrayEXT';
    
    static procedure DisableVertexArrayEXT(vaobj: UInt32; &array: UInt32);
    external 'opengl32.dll' name 'glDisableVertexArrayEXT';
    
    static procedure EnableVertexArrayAttribEXT(vaobj: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glEnableVertexArrayAttribEXT';
    
    static procedure DisableVertexArrayAttribEXT(vaobj: UInt32; index: UInt32);
    external 'opengl32.dll' name 'glDisableVertexArrayAttribEXT';
    
    static procedure GetVertexArrayIntegervEXT(vaobj: UInt32; pname: UInt32; param: ^Int32);
    external 'opengl32.dll' name 'glGetVertexArrayIntegervEXT';
    
    static procedure GetVertexArrayPointervEXT(vaobj: UInt32; pname: UInt32; param: ^IntPtr);
    external 'opengl32.dll' name 'glGetVertexArrayPointervEXT';
    
    static procedure GetVertexArrayIntegeri_vEXT(vaobj: UInt32; index: UInt32; pname: UInt32; param: ^Int32);
    external 'opengl32.dll' name 'glGetVertexArrayIntegeri_vEXT';
    
    static procedure GetVertexArrayPointeri_vEXT(vaobj: UInt32; index: UInt32; pname: UInt32; param: ^IntPtr);
    external 'opengl32.dll' name 'glGetVertexArrayPointeri_vEXT';
    
    static function MapNamedBufferRangeEXT(buffer: UInt32; offset: IntPtr; length: UIntPtr; access: UInt32): pointer;
    external 'opengl32.dll' name 'glMapNamedBufferRangeEXT';
    
    static procedure FlushMappedNamedBufferRangeEXT(buffer: UInt32; offset: IntPtr; length: UIntPtr);
    external 'opengl32.dll' name 'glFlushMappedNamedBufferRangeEXT';
    
    static procedure NamedBufferStorageEXT(buffer: UInt32; size: UIntPtr; data: pointer; flags: UInt32);
    external 'opengl32.dll' name 'glNamedBufferStorageEXT';
    
    static procedure ClearNamedBufferDataEXT(buffer: UInt32; internalformat: UInt32; format: UInt32; &type: UInt32; data: pointer);
    external 'opengl32.dll' name 'glClearNamedBufferDataEXT';
    
    static procedure ClearNamedBufferSubDataEXT(buffer: UInt32; internalformat: UInt32; offset: UIntPtr; size: UIntPtr; format: UInt32; &type: UInt32; data: pointer);
    external 'opengl32.dll' name 'glClearNamedBufferSubDataEXT';
    
    static procedure NamedFramebufferParameteriEXT(framebuffer: UInt32; pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glNamedFramebufferParameteriEXT';
    
    static procedure GetNamedFramebufferParameterivEXT(framebuffer: UInt32; pname: UInt32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetNamedFramebufferParameterivEXT';
    
    static procedure ProgramUniform1dEXT(&program: UInt32; location: Int32; x: real);
    external 'opengl32.dll' name 'glProgramUniform1dEXT';
    
    static procedure ProgramUniform2dEXT(&program: UInt32; location: Int32; x: real; y: real);
    external 'opengl32.dll' name 'glProgramUniform2dEXT';
    
    static procedure ProgramUniform3dEXT(&program: UInt32; location: Int32; x: real; y: real; z: real);
    external 'opengl32.dll' name 'glProgramUniform3dEXT';
    
    static procedure ProgramUniform4dEXT(&program: UInt32; location: Int32; x: real; y: real; z: real; w: real);
    external 'opengl32.dll' name 'glProgramUniform4dEXT';
    
    static procedure ProgramUniform1dvEXT(&program: UInt32; location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glProgramUniform1dvEXT';
    
    static procedure ProgramUniform2dvEXT(&program: UInt32; location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glProgramUniform2dvEXT';
    
    static procedure ProgramUniform3dvEXT(&program: UInt32; location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glProgramUniform3dvEXT';
    
    static procedure ProgramUniform4dvEXT(&program: UInt32; location: Int32; count: Int32; value: ^real);
    external 'opengl32.dll' name 'glProgramUniform4dvEXT';
    
    static procedure ProgramUniformMatrix2dvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix2dvEXT';
    
    static procedure ProgramUniformMatrix3dvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix3dvEXT';
    
    static procedure ProgramUniformMatrix4dvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix4dvEXT';
    
    static procedure ProgramUniformMatrix2x3dvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix2x3dvEXT';
    
    static procedure ProgramUniformMatrix2x4dvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix2x4dvEXT';
    
    static procedure ProgramUniformMatrix3x2dvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix3x2dvEXT';
    
    static procedure ProgramUniformMatrix3x4dvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix3x4dvEXT';
    
    static procedure ProgramUniformMatrix4x2dvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix4x2dvEXT';
    
    static procedure ProgramUniformMatrix4x3dvEXT(&program: UInt32; location: Int32; count: Int32; transpose: GLboolean; value: ^real);
    external 'opengl32.dll' name 'glProgramUniformMatrix4x3dvEXT';
    
    static procedure TextureBufferRangeEXT(texture: UInt32; target: UInt32; internalformat: UInt32; buffer: UInt32; offset: IntPtr; size: UIntPtr);
    external 'opengl32.dll' name 'glTextureBufferRangeEXT';
    
    static procedure TextureStorage1DEXT(texture: UInt32; target: UInt32; levels: Int32; internalformat: UInt32; width: Int32);
    external 'opengl32.dll' name 'glTextureStorage1DEXT';
    
    static procedure TextureStorage2DEXT(texture: UInt32; target: UInt32; levels: Int32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glTextureStorage2DEXT';
    
    static procedure TextureStorage3DEXT(texture: UInt32; target: UInt32; levels: Int32; internalformat: UInt32; width: Int32; height: Int32; depth: Int32);
    external 'opengl32.dll' name 'glTextureStorage3DEXT';
    
    static procedure TextureStorage2DMultisampleEXT(texture: UInt32; target: UInt32; samples: Int32; internalformat: UInt32; width: Int32; height: Int32; fixedsamplelocations: GLboolean);
    external 'opengl32.dll' name 'glTextureStorage2DMultisampleEXT';
    
    static procedure TextureStorage3DMultisampleEXT(texture: UInt32; target: UInt32; samples: Int32; internalformat: UInt32; width: Int32; height: Int32; depth: Int32; fixedsamplelocations: GLboolean);
    external 'opengl32.dll' name 'glTextureStorage3DMultisampleEXT';
    
    static procedure VertexArrayBindVertexBufferEXT(vaobj: UInt32; bindingindex: UInt32; buffer: UInt32; offset: IntPtr; stride: Int32);
    external 'opengl32.dll' name 'glVertexArrayBindVertexBufferEXT';
    
    static procedure VertexArrayVertexAttribFormatEXT(vaobj: UInt32; attribindex: UInt32; size: Int32; &type: UInt32; normalized: GLboolean; relativeoffset: UInt32);
    external 'opengl32.dll' name 'glVertexArrayVertexAttribFormatEXT';
    
    static procedure VertexArrayVertexAttribIFormatEXT(vaobj: UInt32; attribindex: UInt32; size: Int32; &type: UInt32; relativeoffset: UInt32);
    external 'opengl32.dll' name 'glVertexArrayVertexAttribIFormatEXT';
    
    static procedure VertexArrayVertexAttribLFormatEXT(vaobj: UInt32; attribindex: UInt32; size: Int32; &type: UInt32; relativeoffset: UInt32);
    external 'opengl32.dll' name 'glVertexArrayVertexAttribLFormatEXT';
    
    static procedure VertexArrayVertexAttribBindingEXT(vaobj: UInt32; attribindex: UInt32; bindingindex: UInt32);
    external 'opengl32.dll' name 'glVertexArrayVertexAttribBindingEXT';
    
    static procedure VertexArrayVertexBindingDivisorEXT(vaobj: UInt32; bindingindex: UInt32; divisor: UInt32);
    external 'opengl32.dll' name 'glVertexArrayVertexBindingDivisorEXT';
    
    static procedure VertexArrayVertexAttribLOffsetEXT(vaobj: UInt32; buffer: UInt32; index: UInt32; size: Int32; &type: UInt32; stride: Int32; offset: IntPtr);
    external 'opengl32.dll' name 'glVertexArrayVertexAttribLOffsetEXT';
    
    static procedure TexturePageCommitmentEXT(texture: UInt32; level: Int32; xoffset: Int32; yoffset: Int32; zoffset: Int32; width: Int32; height: Int32; depth: Int32; commit: GLboolean);
    external 'opengl32.dll' name 'glTexturePageCommitmentEXT';
    
    static procedure VertexArrayVertexAttribDivisorEXT(vaobj: UInt32; index: UInt32; divisor: UInt32);
    external 'opengl32.dll' name 'glVertexArrayVertexAttribDivisorEXT';
    
    static procedure DrawArraysInstancedEXT(mode: UInt32; start: Int32; count: Int32; primcount: Int32);
    external 'opengl32.dll' name 'glDrawArraysInstancedEXT';
    
    static procedure DrawElementsInstancedEXT(mode: UInt32; count: Int32; &type: UInt32; indices: pointer; primcount: Int32);
    external 'opengl32.dll' name 'glDrawElementsInstancedEXT';
    
    static procedure PolygonOffsetClampEXT(factor: single; units: single; clamp: single);
    external 'opengl32.dll' name 'glPolygonOffsetClampEXT';
    
    static procedure RasterSamplesEXT(samples: UInt32; fixedsamplelocations: GLboolean);
    external 'opengl32.dll' name 'glRasterSamplesEXT';
    
    static procedure UseShaderProgramEXT(&type: UInt32; &program: UInt32);
    external 'opengl32.dll' name 'glUseShaderProgramEXT';
    
    static procedure ActiveProgramEXT(&program: UInt32);
    external 'opengl32.dll' name 'glActiveProgramEXT';
    
    static function CreateShaderProgramEXT(&type: UInt32; string: ^SByte): UInt32;
    external 'opengl32.dll' name 'glCreateShaderProgramEXT';
    
    static procedure FramebufferFetchBarrierEXT;
    external 'opengl32.dll' name 'glFramebufferFetchBarrierEXT';
    
    static procedure WindowRectanglesEXT(mode: UInt32; count: Int32; box: ^Int32);
    external 'opengl32.dll' name 'glWindowRectanglesEXT';
    
    static procedure ApplyFramebufferAttachmentCMAAINTEL;
    external 'opengl32.dll' name 'glApplyFramebufferAttachmentCMAAINTEL';
    
    static procedure BeginPerfQueryINTEL(queryHandle: UInt32);
    external 'opengl32.dll' name 'glBeginPerfQueryINTEL';
    
    static procedure CreatePerfQueryINTEL(queryId: UInt32; queryHandle: ^UInt32);
    external 'opengl32.dll' name 'glCreatePerfQueryINTEL';
    
    static procedure DeletePerfQueryINTEL(queryHandle: UInt32);
    external 'opengl32.dll' name 'glDeletePerfQueryINTEL';
    
    static procedure EndPerfQueryINTEL(queryHandle: UInt32);
    external 'opengl32.dll' name 'glEndPerfQueryINTEL';
    
    static procedure GetFirstPerfQueryIdINTEL(queryId: ^UInt32);
    external 'opengl32.dll' name 'glGetFirstPerfQueryIdINTEL';
    
    static procedure GetNextPerfQueryIdINTEL(queryId: UInt32; nextQueryId: ^UInt32);
    external 'opengl32.dll' name 'glGetNextPerfQueryIdINTEL';
    
    static procedure GetPerfCounterInfoINTEL(queryId: UInt32; counterId: UInt32; counterNameLength: UInt32; counterName: ^SByte; counterDescLength: UInt32; counterDesc: ^SByte; counterOffset: ^UInt32; counterDataSize: ^UInt32; counterTypeEnum: ^UInt32; counterDataTypeEnum: ^UInt32; rawCounterMaxValue: ^UInt64);
    external 'opengl32.dll' name 'glGetPerfCounterInfoINTEL';
    
    static procedure GetPerfQueryDataINTEL(queryHandle: UInt32; flags: UInt32; dataSize: Int32; data: pointer; bytesWritten: ^UInt32);
    external 'opengl32.dll' name 'glGetPerfQueryDataINTEL';
    
    static procedure GetPerfQueryIdByNameINTEL(queryName: ^SByte; queryId: ^UInt32);
    external 'opengl32.dll' name 'glGetPerfQueryIdByNameINTEL';
    
    static procedure GetPerfQueryInfoINTEL(queryId: UInt32; queryNameLength: UInt32; queryName: ^SByte; dataSize: ^UInt32; noCounters: ^UInt32; noInstances: ^UInt32; capsMask: ^UInt32);
    external 'opengl32.dll' name 'glGetPerfQueryInfoINTEL';
    
    static procedure MultiDrawArraysIndirectBindlessNV(mode: UInt32; indirect: pointer; drawCount: Int32; stride: Int32; vertexBufferCount: Int32);
    external 'opengl32.dll' name 'glMultiDrawArraysIndirectBindlessNV';
    
    static procedure MultiDrawElementsIndirectBindlessNV(mode: UInt32; &type: UInt32; indirect: pointer; drawCount: Int32; stride: Int32; vertexBufferCount: Int32);
    external 'opengl32.dll' name 'glMultiDrawElementsIndirectBindlessNV';
    
    static procedure MultiDrawArraysIndirectBindlessCountNV(mode: UInt32; indirect: pointer; drawCount: Int32; maxDrawCount: Int32; stride: Int32; vertexBufferCount: Int32);
    external 'opengl32.dll' name 'glMultiDrawArraysIndirectBindlessCountNV';
    
    static procedure MultiDrawElementsIndirectBindlessCountNV(mode: UInt32; &type: UInt32; indirect: pointer; drawCount: Int32; maxDrawCount: Int32; stride: Int32; vertexBufferCount: Int32);
    external 'opengl32.dll' name 'glMultiDrawElementsIndirectBindlessCountNV';
    
    static function GetTextureHandleNV(texture: UInt32): UInt64;
    external 'opengl32.dll' name 'glGetTextureHandleNV';
    
    static function GetTextureSamplerHandleNV(texture: UInt32; sampler: UInt32): UInt64;
    external 'opengl32.dll' name 'glGetTextureSamplerHandleNV';
    
    static procedure MakeTextureHandleResidentNV(handle: UInt64);
    external 'opengl32.dll' name 'glMakeTextureHandleResidentNV';
    
    static procedure MakeTextureHandleNonResidentNV(handle: UInt64);
    external 'opengl32.dll' name 'glMakeTextureHandleNonResidentNV';
    
    static function GetImageHandleNV(texture: UInt32; level: Int32; layered: GLboolean; layer: Int32; format: UInt32): UInt64;
    external 'opengl32.dll' name 'glGetImageHandleNV';
    
    static procedure MakeImageHandleResidentNV(handle: UInt64; access: UInt32);
    external 'opengl32.dll' name 'glMakeImageHandleResidentNV';
    
    static procedure MakeImageHandleNonResidentNV(handle: UInt64);
    external 'opengl32.dll' name 'glMakeImageHandleNonResidentNV';
    
    static procedure UniformHandleui64NV(location: Int32; value: UInt64);
    external 'opengl32.dll' name 'glUniformHandleui64NV';
    
    static procedure UniformHandleui64vNV(location: Int32; count: Int32; value: ^UInt64);
    external 'opengl32.dll' name 'glUniformHandleui64vNV';
    
    static procedure ProgramUniformHandleui64NV(&program: UInt32; location: Int32; value: UInt64);
    external 'opengl32.dll' name 'glProgramUniformHandleui64NV';
    
    static procedure ProgramUniformHandleui64vNV(&program: UInt32; location: Int32; count: Int32; values: ^UInt64);
    external 'opengl32.dll' name 'glProgramUniformHandleui64vNV';
    
    static function IsTextureHandleResidentNV(handle: UInt64): GLboolean;
    external 'opengl32.dll' name 'glIsTextureHandleResidentNV';
    
    static function IsImageHandleResidentNV(handle: UInt64): GLboolean;
    external 'opengl32.dll' name 'glIsImageHandleResidentNV';
    
    static procedure BlendParameteriNV(pname: UInt32; value: Int32);
    external 'opengl32.dll' name 'glBlendParameteriNV';
    
    static procedure BlendBarrierNV;
    external 'opengl32.dll' name 'glBlendBarrierNV';
    
    static procedure ViewportPositionWScaleNV(index: UInt32; xcoeff: single; ycoeff: single);
    external 'opengl32.dll' name 'glViewportPositionWScaleNV';
    
    static procedure CreateStatesNV(n: Int32; states: ^UInt32);
    external 'opengl32.dll' name 'glCreateStatesNV';
    
    static procedure DeleteStatesNV(n: Int32; states: ^UInt32);
    external 'opengl32.dll' name 'glDeleteStatesNV';
    
    static function IsStateNV(state: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsStateNV';
    
    static procedure StateCaptureNV(state: UInt32; mode: UInt32);
    external 'opengl32.dll' name 'glStateCaptureNV';
    
    static function GetCommandHeaderNV(tokenID: UInt32; size: UInt32): UInt32;
    external 'opengl32.dll' name 'glGetCommandHeaderNV';
    
    static function GetStageIndexNV(shadertype: UInt32): UInt16;
    external 'opengl32.dll' name 'glGetStageIndexNV';
    
    static procedure DrawCommandsNV(primitiveMode: UInt32; buffer: UInt32; indirects: ^IntPtr; sizes: ^Int32; count: UInt32);
    external 'opengl32.dll' name 'glDrawCommandsNV';
    
    static procedure DrawCommandsAddressNV(primitiveMode: UInt32; indirects: ^UInt64; sizes: ^Int32; count: UInt32);
    external 'opengl32.dll' name 'glDrawCommandsAddressNV';
    
    static procedure DrawCommandsStatesNV(buffer: UInt32; indirects: ^IntPtr; sizes: ^Int32; states: ^UInt32; fbos: ^UInt32; count: UInt32);
    external 'opengl32.dll' name 'glDrawCommandsStatesNV';
    
    static procedure DrawCommandsStatesAddressNV(indirects: ^UInt64; sizes: ^Int32; states: ^UInt32; fbos: ^UInt32; count: UInt32);
    external 'opengl32.dll' name 'glDrawCommandsStatesAddressNV';
    
    static procedure CreateCommandListsNV(n: Int32; lists: ^UInt32);
    external 'opengl32.dll' name 'glCreateCommandListsNV';
    
    static procedure DeleteCommandListsNV(n: Int32; lists: ^UInt32);
    external 'opengl32.dll' name 'glDeleteCommandListsNV';
    
    static function IsCommandListNV(list: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsCommandListNV';
    
    static procedure ListDrawCommandsStatesClientNV(list: UInt32; segment: UInt32; indirects: ^IntPtr; sizes: ^Int32; states: ^UInt32; fbos: ^UInt32; count: UInt32);
    external 'opengl32.dll' name 'glListDrawCommandsStatesClientNV';
    
    static procedure CommandListSegmentsNV(list: UInt32; segments: UInt32);
    external 'opengl32.dll' name 'glCommandListSegmentsNV';
    
    static procedure CompileCommandListNV(list: UInt32);
    external 'opengl32.dll' name 'glCompileCommandListNV';
    
    static procedure CallCommandListNV(list: UInt32);
    external 'opengl32.dll' name 'glCallCommandListNV';
    
    static procedure BeginConditionalRenderNV(id: UInt32; mode: UInt32);
    external 'opengl32.dll' name 'glBeginConditionalRenderNV';
    
    static procedure EndConditionalRenderNV;
    external 'opengl32.dll' name 'glEndConditionalRenderNV';
    
    static procedure SubpixelPrecisionBiasNV(xbits: UInt32; ybits: UInt32);
    external 'opengl32.dll' name 'glSubpixelPrecisionBiasNV';
    
    static procedure ConservativeRasterParameterfNV(pname: UInt32; value: single);
    external 'opengl32.dll' name 'glConservativeRasterParameterfNV';
    
    static procedure ConservativeRasterParameteriNV(pname: UInt32; param: Int32);
    external 'opengl32.dll' name 'glConservativeRasterParameteriNV';
    
    static procedure DrawVkImageNV(vkImage: UInt64; sampler: UInt32; x0: single; y0: single; x1: single; y1: single; z: single; s0: single; t0: single; s1: single; t1: single);
    external 'opengl32.dll' name 'glDrawVkImageNV';
    
    static function GetVkProcAddrNV(name: ^SByte): GLVULKANPROCNV;
    external 'opengl32.dll' name 'glGetVkProcAddrNV';
    
    static procedure WaitVkSemaphoreNV(vkSemaphore: UInt64);
    external 'opengl32.dll' name 'glWaitVkSemaphoreNV';
    
    static procedure SignalVkSemaphoreNV(vkSemaphore: UInt64);
    external 'opengl32.dll' name 'glSignalVkSemaphoreNV';
    
    static procedure SignalVkFenceNV(vkFence: UInt64);
    external 'opengl32.dll' name 'glSignalVkFenceNV';
    
    static procedure FragmentCoverageColorNV(color: UInt32);
    external 'opengl32.dll' name 'glFragmentCoverageColorNV';
    
    static procedure CoverageModulationTableNV(n: Int32; v: ^single);
    external 'opengl32.dll' name 'glCoverageModulationTableNV';
    
    static procedure GetCoverageModulationTableNV(bufsize: Int32; v: ^single);
    external 'opengl32.dll' name 'glGetCoverageModulationTableNV';
    
    static procedure CoverageModulationNV(components: UInt32);
    external 'opengl32.dll' name 'glCoverageModulationNV';
    
    static procedure RenderbufferStorageMultisampleCoverageNV(target: UInt32; coverageSamples: Int32; colorSamples: Int32; internalformat: UInt32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glRenderbufferStorageMultisampleCoverageNV';
    
    static procedure Uniform1i64NV(location: Int32; x: Int64EXT);
    external 'opengl32.dll' name 'glUniform1i64NV';
    
    static procedure Uniform2i64NV(location: Int32; x: Int64EXT; y: Int64EXT);
    external 'opengl32.dll' name 'glUniform2i64NV';
    
    static procedure Uniform3i64NV(location: Int32; x: Int64EXT; y: Int64EXT; z: Int64EXT);
    external 'opengl32.dll' name 'glUniform3i64NV';
    
    static procedure Uniform4i64NV(location: Int32; x: Int64EXT; y: Int64EXT; z: Int64EXT; w: Int64EXT);
    external 'opengl32.dll' name 'glUniform4i64NV';
    
    static procedure Uniform1i64vNV(location: Int32; count: Int32; value: ^Int64EXT);
    external 'opengl32.dll' name 'glUniform1i64vNV';
    
    static procedure Uniform2i64vNV(location: Int32; count: Int32; value: ^Int64EXT);
    external 'opengl32.dll' name 'glUniform2i64vNV';
    
    static procedure Uniform3i64vNV(location: Int32; count: Int32; value: ^Int64EXT);
    external 'opengl32.dll' name 'glUniform3i64vNV';
    
    static procedure Uniform4i64vNV(location: Int32; count: Int32; value: ^Int64EXT);
    external 'opengl32.dll' name 'glUniform4i64vNV';
    
    static procedure Uniform1ui64NV(location: Int32; x: UInt64EXT);
    external 'opengl32.dll' name 'glUniform1ui64NV';
    
    static procedure Uniform2ui64NV(location: Int32; x: UInt64EXT; y: UInt64EXT);
    external 'opengl32.dll' name 'glUniform2ui64NV';
    
    static procedure Uniform3ui64NV(location: Int32; x: UInt64EXT; y: UInt64EXT; z: UInt64EXT);
    external 'opengl32.dll' name 'glUniform3ui64NV';
    
    static procedure Uniform4ui64NV(location: Int32; x: UInt64EXT; y: UInt64EXT; z: UInt64EXT; w: UInt64EXT);
    external 'opengl32.dll' name 'glUniform4ui64NV';
    
    static procedure Uniform1ui64vNV(location: Int32; count: Int32; value: ^UInt64EXT);
    external 'opengl32.dll' name 'glUniform1ui64vNV';
    
    static procedure Uniform2ui64vNV(location: Int32; count: Int32; value: ^UInt64EXT);
    external 'opengl32.dll' name 'glUniform2ui64vNV';
    
    static procedure Uniform3ui64vNV(location: Int32; count: Int32; value: ^UInt64EXT);
    external 'opengl32.dll' name 'glUniform3ui64vNV';
    
    static procedure Uniform4ui64vNV(location: Int32; count: Int32; value: ^UInt64EXT);
    external 'opengl32.dll' name 'glUniform4ui64vNV';
    
    static procedure GetUniformi64vNV(&program: UInt32; location: Int32; &params: ^Int64EXT);
    external 'opengl32.dll' name 'glGetUniformi64vNV';
    
    static procedure ProgramUniform1i64NV(&program: UInt32; location: Int32; x: Int64EXT);
    external 'opengl32.dll' name 'glProgramUniform1i64NV';
    
    static procedure ProgramUniform2i64NV(&program: UInt32; location: Int32; x: Int64EXT; y: Int64EXT);
    external 'opengl32.dll' name 'glProgramUniform2i64NV';
    
    static procedure ProgramUniform3i64NV(&program: UInt32; location: Int32; x: Int64EXT; y: Int64EXT; z: Int64EXT);
    external 'opengl32.dll' name 'glProgramUniform3i64NV';
    
    static procedure ProgramUniform4i64NV(&program: UInt32; location: Int32; x: Int64EXT; y: Int64EXT; z: Int64EXT; w: Int64EXT);
    external 'opengl32.dll' name 'glProgramUniform4i64NV';
    
    static procedure ProgramUniform1i64vNV(&program: UInt32; location: Int32; count: Int32; value: ^Int64EXT);
    external 'opengl32.dll' name 'glProgramUniform1i64vNV';
    
    static procedure ProgramUniform2i64vNV(&program: UInt32; location: Int32; count: Int32; value: ^Int64EXT);
    external 'opengl32.dll' name 'glProgramUniform2i64vNV';
    
    static procedure ProgramUniform3i64vNV(&program: UInt32; location: Int32; count: Int32; value: ^Int64EXT);
    external 'opengl32.dll' name 'glProgramUniform3i64vNV';
    
    static procedure ProgramUniform4i64vNV(&program: UInt32; location: Int32; count: Int32; value: ^Int64EXT);
    external 'opengl32.dll' name 'glProgramUniform4i64vNV';
    
    static procedure ProgramUniform1ui64NV(&program: UInt32; location: Int32; x: UInt64EXT);
    external 'opengl32.dll' name 'glProgramUniform1ui64NV';
    
    static procedure ProgramUniform2ui64NV(&program: UInt32; location: Int32; x: UInt64EXT; y: UInt64EXT);
    external 'opengl32.dll' name 'glProgramUniform2ui64NV';
    
    static procedure ProgramUniform3ui64NV(&program: UInt32; location: Int32; x: UInt64EXT; y: UInt64EXT; z: UInt64EXT);
    external 'opengl32.dll' name 'glProgramUniform3ui64NV';
    
    static procedure ProgramUniform4ui64NV(&program: UInt32; location: Int32; x: UInt64EXT; y: UInt64EXT; z: UInt64EXT; w: UInt64EXT);
    external 'opengl32.dll' name 'glProgramUniform4ui64NV';
    
    static procedure ProgramUniform1ui64vNV(&program: UInt32; location: Int32; count: Int32; value: ^UInt64EXT);
    external 'opengl32.dll' name 'glProgramUniform1ui64vNV';
    
    static procedure ProgramUniform2ui64vNV(&program: UInt32; location: Int32; count: Int32; value: ^UInt64EXT);
    external 'opengl32.dll' name 'glProgramUniform2ui64vNV';
    
    static procedure ProgramUniform3ui64vNV(&program: UInt32; location: Int32; count: Int32; value: ^UInt64EXT);
    external 'opengl32.dll' name 'glProgramUniform3ui64vNV';
    
    static procedure ProgramUniform4ui64vNV(&program: UInt32; location: Int32; count: Int32; value: ^UInt64EXT);
    external 'opengl32.dll' name 'glProgramUniform4ui64vNV';
    
    static procedure GetInternalformatSampleivNV(target: UInt32; internalformat: UInt32; samples: Int32; pname: UInt32; bufSize: Int32; &params: ^Int32);
    external 'opengl32.dll' name 'glGetInternalformatSampleivNV';
    
    static procedure GetMemoryObjectDetachedResourcesuivNV(memory: UInt32; pname: UInt32; first: Int32; count: Int32; &params: ^UInt32);
    external 'opengl32.dll' name 'glGetMemoryObjectDetachedResourcesuivNV';
    
    static procedure ResetMemoryObjectParameterNV(memory: UInt32; pname: UInt32);
    external 'opengl32.dll' name 'glResetMemoryObjectParameterNV';
    
    static procedure TexAttachMemoryNV(target: UInt32; memory: UInt32; offset: UInt64);
    external 'opengl32.dll' name 'glTexAttachMemoryNV';
    
    static procedure BufferAttachMemoryNV(target: UInt32; memory: UInt32; offset: UInt64);
    external 'opengl32.dll' name 'glBufferAttachMemoryNV';
    
    static procedure TextureAttachMemoryNV(texture: UInt32; memory: UInt32; offset: UInt64);
    external 'opengl32.dll' name 'glTextureAttachMemoryNV';
    
    static procedure NamedBufferAttachMemoryNV(buffer: UInt32; memory: UInt32; offset: UInt64);
    external 'opengl32.dll' name 'glNamedBufferAttachMemoryNV';
    
    static procedure DrawMeshTasksNV(first: UInt32; count: UInt32);
    external 'opengl32.dll' name 'glDrawMeshTasksNV';
    
    static procedure DrawMeshTasksIndirectNV(indirect: IntPtr);
    external 'opengl32.dll' name 'glDrawMeshTasksIndirectNV';
    
    static procedure MultiDrawMeshTasksIndirectNV(indirect: IntPtr; drawcount: Int32; stride: Int32);
    external 'opengl32.dll' name 'glMultiDrawMeshTasksIndirectNV';
    
    static procedure MultiDrawMeshTasksIndirectCountNV(indirect: IntPtr; drawcount: IntPtr; maxdrawcount: Int32; stride: Int32);
    external 'opengl32.dll' name 'glMultiDrawMeshTasksIndirectCountNV';
    
    static function GenPathsNV(range: Int32): UInt32;
    external 'opengl32.dll' name 'glGenPathsNV';
    
    static procedure DeletePathsNV(path: UInt32; range: Int32);
    external 'opengl32.dll' name 'glDeletePathsNV';
    
    static function IsPathNV(path: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsPathNV';
    
    static procedure PathCommandsNV(path: UInt32; numCommands: Int32; commands: ^Byte; numCoords: Int32; coordType: UInt32; coords: pointer);
    external 'opengl32.dll' name 'glPathCommandsNV';
    
    static procedure PathCoordsNV(path: UInt32; numCoords: Int32; coordType: UInt32; coords: pointer);
    external 'opengl32.dll' name 'glPathCoordsNV';
    
    static procedure PathSubCommandsNV(path: UInt32; commandStart: Int32; commandsToDelete: Int32; numCommands: Int32; commands: ^Byte; numCoords: Int32; coordType: UInt32; coords: pointer);
    external 'opengl32.dll' name 'glPathSubCommandsNV';
    
    static procedure PathSubCoordsNV(path: UInt32; coordStart: Int32; numCoords: Int32; coordType: UInt32; coords: pointer);
    external 'opengl32.dll' name 'glPathSubCoordsNV';
    
    static procedure PathStringNV(path: UInt32; format: UInt32; length: Int32; pathString: pointer);
    external 'opengl32.dll' name 'glPathStringNV';
    
    static procedure PathGlyphsNV(firstPathName: UInt32; fontTarget: UInt32; fontName: pointer; fontStyle: UInt32; numGlyphs: Int32; &type: UInt32; charcodes: pointer; handleMissingGlyphs: UInt32; pathParameterTemplate: UInt32; emScale: single);
    external 'opengl32.dll' name 'glPathGlyphsNV';
    
    static procedure PathGlyphRangeNV(firstPathName: UInt32; fontTarget: UInt32; fontName: pointer; fontStyle: UInt32; firstGlyph: UInt32; numGlyphs: Int32; handleMissingGlyphs: UInt32; pathParameterTemplate: UInt32; emScale: single);
    external 'opengl32.dll' name 'glPathGlyphRangeNV';
    
    static procedure WeightPathsNV(resultPath: UInt32; numPaths: Int32; paths: ^UInt32; weights: ^single);
    external 'opengl32.dll' name 'glWeightPathsNV';
    
    static procedure CopyPathNV(resultPath: UInt32; srcPath: UInt32);
    external 'opengl32.dll' name 'glCopyPathNV';
    
    static procedure InterpolatePathsNV(resultPath: UInt32; pathA: UInt32; pathB: UInt32; weight: single);
    external 'opengl32.dll' name 'glInterpolatePathsNV';
    
    static procedure TransformPathNV(resultPath: UInt32; srcPath: UInt32; transformType: UInt32; transformValues: ^single);
    external 'opengl32.dll' name 'glTransformPathNV';
    
    static procedure PathParameterivNV(path: UInt32; pname: UInt32; value: ^Int32);
    external 'opengl32.dll' name 'glPathParameterivNV';
    
    static procedure PathParameteriNV(path: UInt32; pname: UInt32; value: Int32);
    external 'opengl32.dll' name 'glPathParameteriNV';
    
    static procedure PathParameterfvNV(path: UInt32; pname: UInt32; value: ^single);
    external 'opengl32.dll' name 'glPathParameterfvNV';
    
    static procedure PathParameterfNV(path: UInt32; pname: UInt32; value: single);
    external 'opengl32.dll' name 'glPathParameterfNV';
    
    static procedure PathDashArrayNV(path: UInt32; dashCount: Int32; dashArray: ^single);
    external 'opengl32.dll' name 'glPathDashArrayNV';
    
    static procedure PathStencilFuncNV(func: UInt32; ref: Int32; mask: UInt32);
    external 'opengl32.dll' name 'glPathStencilFuncNV';
    
    static procedure PathStencilDepthOffsetNV(factor: single; units: single);
    external 'opengl32.dll' name 'glPathStencilDepthOffsetNV';
    
    static procedure StencilFillPathNV(path: UInt32; fillMode: UInt32; mask: UInt32);
    external 'opengl32.dll' name 'glStencilFillPathNV';
    
    static procedure StencilStrokePathNV(path: UInt32; reference: Int32; mask: UInt32);
    external 'opengl32.dll' name 'glStencilStrokePathNV';
    
    static procedure StencilFillPathInstancedNV(numPaths: Int32; pathNameType: UInt32; paths: pointer; pathBase: UInt32; fillMode: UInt32; mask: UInt32; transformType: UInt32; transformValues: ^single);
    external 'opengl32.dll' name 'glStencilFillPathInstancedNV';
    
    static procedure StencilStrokePathInstancedNV(numPaths: Int32; pathNameType: UInt32; paths: pointer; pathBase: UInt32; reference: Int32; mask: UInt32; transformType: UInt32; transformValues: ^single);
    external 'opengl32.dll' name 'glStencilStrokePathInstancedNV';
    
    static procedure PathCoverDepthFuncNV(func: UInt32);
    external 'opengl32.dll' name 'glPathCoverDepthFuncNV';
    
    static procedure CoverFillPathNV(path: UInt32; coverMode: UInt32);
    external 'opengl32.dll' name 'glCoverFillPathNV';
    
    static procedure CoverStrokePathNV(path: UInt32; coverMode: UInt32);
    external 'opengl32.dll' name 'glCoverStrokePathNV';
    
    static procedure CoverFillPathInstancedNV(numPaths: Int32; pathNameType: UInt32; paths: pointer; pathBase: UInt32; coverMode: UInt32; transformType: UInt32; transformValues: ^single);
    external 'opengl32.dll' name 'glCoverFillPathInstancedNV';
    
    static procedure CoverStrokePathInstancedNV(numPaths: Int32; pathNameType: UInt32; paths: pointer; pathBase: UInt32; coverMode: UInt32; transformType: UInt32; transformValues: ^single);
    external 'opengl32.dll' name 'glCoverStrokePathInstancedNV';
    
    static procedure GetPathParameterivNV(path: UInt32; pname: UInt32; value: ^Int32);
    external 'opengl32.dll' name 'glGetPathParameterivNV';
    
    static procedure GetPathParameterfvNV(path: UInt32; pname: UInt32; value: ^single);
    external 'opengl32.dll' name 'glGetPathParameterfvNV';
    
    static procedure GetPathCommandsNV(path: UInt32; commands: ^Byte);
    external 'opengl32.dll' name 'glGetPathCommandsNV';
    
    static procedure GetPathCoordsNV(path: UInt32; coords: ^single);
    external 'opengl32.dll' name 'glGetPathCoordsNV';
    
    static procedure GetPathDashArrayNV(path: UInt32; dashArray: ^single);
    external 'opengl32.dll' name 'glGetPathDashArrayNV';
    
    static procedure GetPathMetricsNV(metricQueryMask: UInt32; numPaths: Int32; pathNameType: UInt32; paths: pointer; pathBase: UInt32; stride: Int32; metrics: ^single);
    external 'opengl32.dll' name 'glGetPathMetricsNV';
    
    static procedure GetPathMetricRangeNV(metricQueryMask: UInt32; firstPathName: UInt32; numPaths: Int32; stride: Int32; metrics: ^single);
    external 'opengl32.dll' name 'glGetPathMetricRangeNV';
    
    static procedure GetPathSpacingNV(pathListMode: UInt32; numPaths: Int32; pathNameType: UInt32; paths: pointer; pathBase: UInt32; advanceScale: single; kerningScale: single; transformType: UInt32; returnedSpacing: ^single);
    external 'opengl32.dll' name 'glGetPathSpacingNV';
    
    static function IsPointInFillPathNV(path: UInt32; mask: UInt32; x: single; y: single): GLboolean;
    external 'opengl32.dll' name 'glIsPointInFillPathNV';
    
    static function IsPointInStrokePathNV(path: UInt32; x: single; y: single): GLboolean;
    external 'opengl32.dll' name 'glIsPointInStrokePathNV';
    
    static function GetPathLengthNV(path: UInt32; startSegment: Int32; numSegments: Int32): single;
    external 'opengl32.dll' name 'glGetPathLengthNV';
    
    static function PointAlongPathNV(path: UInt32; startSegment: Int32; numSegments: Int32; distance: single; x: ^single; y: ^single; tangentX: ^single; tangentY: ^single): GLboolean;
    external 'opengl32.dll' name 'glPointAlongPathNV';
    
    static procedure MatrixLoad3x2fNV(matrixMode: UInt32; m: ^single);
    external 'opengl32.dll' name 'glMatrixLoad3x2fNV';
    
    static procedure MatrixLoad3x3fNV(matrixMode: UInt32; m: ^single);
    external 'opengl32.dll' name 'glMatrixLoad3x3fNV';
    
    static procedure MatrixLoadTranspose3x3fNV(matrixMode: UInt32; m: ^single);
    external 'opengl32.dll' name 'glMatrixLoadTranspose3x3fNV';
    
    static procedure MatrixMult3x2fNV(matrixMode: UInt32; m: ^single);
    external 'opengl32.dll' name 'glMatrixMult3x2fNV';
    
    static procedure MatrixMult3x3fNV(matrixMode: UInt32; m: ^single);
    external 'opengl32.dll' name 'glMatrixMult3x3fNV';
    
    static procedure MatrixMultTranspose3x3fNV(matrixMode: UInt32; m: ^single);
    external 'opengl32.dll' name 'glMatrixMultTranspose3x3fNV';
    
    static procedure StencilThenCoverFillPathNV(path: UInt32; fillMode: UInt32; mask: UInt32; coverMode: UInt32);
    external 'opengl32.dll' name 'glStencilThenCoverFillPathNV';
    
    static procedure StencilThenCoverStrokePathNV(path: UInt32; reference: Int32; mask: UInt32; coverMode: UInt32);
    external 'opengl32.dll' name 'glStencilThenCoverStrokePathNV';
    
    static procedure StencilThenCoverFillPathInstancedNV(numPaths: Int32; pathNameType: UInt32; paths: pointer; pathBase: UInt32; fillMode: UInt32; mask: UInt32; coverMode: UInt32; transformType: UInt32; transformValues: ^single);
    external 'opengl32.dll' name 'glStencilThenCoverFillPathInstancedNV';
    
    static procedure StencilThenCoverStrokePathInstancedNV(numPaths: Int32; pathNameType: UInt32; paths: pointer; pathBase: UInt32; reference: Int32; mask: UInt32; coverMode: UInt32; transformType: UInt32; transformValues: ^single);
    external 'opengl32.dll' name 'glStencilThenCoverStrokePathInstancedNV';
    
    static function PathGlyphIndexRangeNV(fontTarget: UInt32; fontName: pointer; fontStyle: UInt32; pathParameterTemplate: UInt32; emScale: single; baseAndCount: Vec2ui32): UInt32;
    external 'opengl32.dll' name 'glPathGlyphIndexRangeNV';
    
    static function PathGlyphIndexArrayNV(firstPathName: UInt32; fontTarget: UInt32; fontName: pointer; fontStyle: UInt32; firstGlyphIndex: UInt32; numGlyphs: Int32; pathParameterTemplate: UInt32; emScale: single): UInt32;
    external 'opengl32.dll' name 'glPathGlyphIndexArrayNV';
    
    static function PathMemoryGlyphIndexArrayNV(firstPathName: UInt32; fontTarget: UInt32; fontSize: UIntPtr; fontData: pointer; faceIndex: Int32; firstGlyphIndex: UInt32; numGlyphs: Int32; pathParameterTemplate: UInt32; emScale: single): UInt32;
    external 'opengl32.dll' name 'glPathMemoryGlyphIndexArrayNV';
    
    static procedure ProgramPathFragmentInputGenNV(&program: UInt32; location: Int32; genMode: UInt32; components: Int32; coeffs: ^single);
    external 'opengl32.dll' name 'glProgramPathFragmentInputGenNV';
    
    static procedure GetProgramResourcefvNV(&program: UInt32; programInterface: UInt32; index: UInt32; propCount: Int32; props: ^UInt32; bufSize: Int32; length: ^Int32; &params: ^single);
    external 'opengl32.dll' name 'glGetProgramResourcefvNV';
    
    static procedure FramebufferSampleLocationsfvNV(target: UInt32; start: UInt32; count: Int32; v: ^single);
    external 'opengl32.dll' name 'glFramebufferSampleLocationsfvNV';
    
    static procedure NamedFramebufferSampleLocationsfvNV(framebuffer: UInt32; start: UInt32; count: Int32; v: ^single);
    external 'opengl32.dll' name 'glNamedFramebufferSampleLocationsfvNV';
    
    static procedure ResolveDepthValuesNV;
    external 'opengl32.dll' name 'glResolveDepthValuesNV';
    
    static procedure ScissorExclusiveNV(x: Int32; y: Int32; width: Int32; height: Int32);
    external 'opengl32.dll' name 'glScissorExclusiveNV';
    
    static procedure ScissorExclusiveArrayvNV(first: UInt32; count: Int32; v: ^Int32);
    external 'opengl32.dll' name 'glScissorExclusiveArrayvNV';
    
    static procedure MakeBufferResidentNV(target: UInt32; access: UInt32);
    external 'opengl32.dll' name 'glMakeBufferResidentNV';
    
    static procedure MakeBufferNonResidentNV(target: UInt32);
    external 'opengl32.dll' name 'glMakeBufferNonResidentNV';
    
    static function IsBufferResidentNV(target: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsBufferResidentNV';
    
    static procedure MakeNamedBufferResidentNV(buffer: UInt32; access: UInt32);
    external 'opengl32.dll' name 'glMakeNamedBufferResidentNV';
    
    static procedure MakeNamedBufferNonResidentNV(buffer: UInt32);
    external 'opengl32.dll' name 'glMakeNamedBufferNonResidentNV';
    
    static function IsNamedBufferResidentNV(buffer: UInt32): GLboolean;
    external 'opengl32.dll' name 'glIsNamedBufferResidentNV';
    
    static procedure GetBufferParameterui64vNV(target: UInt32; pname: UInt32; &params: ^UInt64EXT);
    external 'opengl32.dll' name 'glGetBufferParameterui64vNV';
    
    static procedure GetNamedBufferParameterui64vNV(buffer: UInt32; pname: UInt32; &params: ^UInt64EXT);
    external 'opengl32.dll' name 'glGetNamedBufferParameterui64vNV';
    
    static procedure GetIntegerui64vNV(value: UInt32; result: ^UInt64EXT);
    external 'opengl32.dll' name 'glGetIntegerui64vNV';
    
    static procedure Uniformui64NV(location: Int32; value: UInt64EXT);
    external 'opengl32.dll' name 'glUniformui64NV';
    
    static procedure Uniformui64vNV(location: Int32; count: Int32; value: ^UInt64EXT);
    external 'opengl32.dll' name 'glUniformui64vNV';
    
    static procedure GetUniformui64vNV(&program: UInt32; location: Int32; &params: ^UInt64EXT);
    external 'opengl32.dll' name 'glGetUniformui64vNV';
    
    static procedure ProgramUniformui64NV(&program: UInt32; location: Int32; value: UInt64EXT);
    external 'opengl32.dll' name 'glProgramUniformui64NV';
    
    static procedure ProgramUniformui64vNV(&program: UInt32; location: Int32; count: Int32; value: ^UInt64EXT);
    external 'opengl32.dll' name 'glProgramUniformui64vNV';
    
    static procedure BindShadingRateImageNV(texture: UInt32);
    external 'opengl32.dll' name 'glBindShadingRateImageNV';
    
    static procedure GetShadingRateImagePaletteNV(viewport: UInt32; entry: UInt32; rate: ^UInt32);
    external 'opengl32.dll' name 'glGetShadingRateImagePaletteNV';
    
    static procedure GetShadingRateSampleLocationivNV(rate: UInt32; samples: UInt32; index: UInt32; location: ^Int32);
    external 'opengl32.dll' name 'glGetShadingRateSampleLocationivNV';
    
    static procedure ShadingRateImageBarrierNV(synchronize: GLboolean);
    external 'opengl32.dll' name 'glShadingRateImageBarrierNV';
    
    static procedure ShadingRateImagePaletteNV(viewport: UInt32; first: UInt32; count: Int32; rates: ^UInt32);
    external 'opengl32.dll' name 'glShadingRateImagePaletteNV';
    
    static procedure ShadingRateSampleOrderNV(order: UInt32);
    external 'opengl32.dll' name 'glShadingRateSampleOrderNV';
    
    static procedure ShadingRateSampleOrderCustomNV(rate: UInt32; samples: UInt32; locations: ^Int32);
    external 'opengl32.dll' name 'glShadingRateSampleOrderCustomNV';
    
    static procedure TextureBarrierNV;
    external 'opengl32.dll' name 'glTextureBarrierNV';
    
    static procedure VertexAttribL1i64NV(index: UInt32; x: Int64EXT);
    external 'opengl32.dll' name 'glVertexAttribL1i64NV';
    
    static procedure VertexAttribL2i64NV(index: UInt32; x: Int64EXT; y: Int64EXT);
    external 'opengl32.dll' name 'glVertexAttribL2i64NV';
    
    static procedure VertexAttribL3i64NV(index: UInt32; x: Int64EXT; y: Int64EXT; z: Int64EXT);
    external 'opengl32.dll' name 'glVertexAttribL3i64NV';
    
    static procedure VertexAttribL4i64NV(index: UInt32; x: Int64EXT; y: Int64EXT; z: Int64EXT; w: Int64EXT);
    external 'opengl32.dll' name 'glVertexAttribL4i64NV';
    
    static procedure VertexAttribL1i64vNV(index: UInt32; v: ^Int64EXT);
    external 'opengl32.dll' name 'glVertexAttribL1i64vNV';
    
    static procedure VertexAttribL2i64vNV(index: UInt32; v: ^Int64EXT);
    external 'opengl32.dll' name 'glVertexAttribL2i64vNV';
    
    static procedure VertexAttribL3i64vNV(index: UInt32; v: ^Int64EXT);
    external 'opengl32.dll' name 'glVertexAttribL3i64vNV';
    
    static procedure VertexAttribL4i64vNV(index: UInt32; v: ^Int64EXT);
    external 'opengl32.dll' name 'glVertexAttribL4i64vNV';
    
    static procedure VertexAttribL1ui64NV(index: UInt32; x: UInt64EXT);
    external 'opengl32.dll' name 'glVertexAttribL1ui64NV';
    
    static procedure VertexAttribL2ui64NV(index: UInt32; x: UInt64EXT; y: UInt64EXT);
    external 'opengl32.dll' name 'glVertexAttribL2ui64NV';
    
    static procedure VertexAttribL3ui64NV(index: UInt32; x: UInt64EXT; y: UInt64EXT; z: UInt64EXT);
    external 'opengl32.dll' name 'glVertexAttribL3ui64NV';
    
    static procedure VertexAttribL4ui64NV(index: UInt32; x: UInt64EXT; y: UInt64EXT; z: UInt64EXT; w: UInt64EXT);
    external 'opengl32.dll' name 'glVertexAttribL4ui64NV';
    
    static procedure VertexAttribL1ui64vNV(index: UInt32; v: ^UInt64EXT);
    external 'opengl32.dll' name 'glVertexAttribL1ui64vNV';
    
    static procedure VertexAttribL2ui64vNV(index: UInt32; v: ^UInt64EXT);
    external 'opengl32.dll' name 'glVertexAttribL2ui64vNV';
    
    static procedure VertexAttribL3ui64vNV(index: UInt32; v: ^UInt64EXT);
    external 'opengl32.dll' name 'glVertexAttribL3ui64vNV';
    
    static procedure VertexAttribL4ui64vNV(index: UInt32; v: ^UInt64EXT);
    external 'opengl32.dll' name 'glVertexAttribL4ui64vNV';
    
    static procedure GetVertexAttribLi64vNV(index: UInt32; pname: UInt32; &params: ^Int64EXT);
    external 'opengl32.dll' name 'glGetVertexAttribLi64vNV';
    
    static procedure GetVertexAttribLui64vNV(index: UInt32; pname: UInt32; &params: ^UInt64EXT);
    external 'opengl32.dll' name 'glGetVertexAttribLui64vNV';
    
    static procedure VertexAttribLFormatNV(index: UInt32; size: Int32; &type: UInt32; stride: Int32);
    external 'opengl32.dll' name 'glVertexAttribLFormatNV';
    
    static procedure BufferAddressRangeNV(pname: UInt32; index: UInt32; address: UInt64EXT; length: UIntPtr);
    external 'opengl32.dll' name 'glBufferAddressRangeNV';
    
    static procedure VertexFormatNV(size: Int32; &type: UInt32; stride: Int32);
    external 'opengl32.dll' name 'glVertexFormatNV';
    
    static procedure NormalFormatNV(&type: UInt32; stride: Int32);
    external 'opengl32.dll' name 'glNormalFormatNV';
    
    static procedure ColorFormatNV(size: Int32; &type: UInt32; stride: Int32);
    external 'opengl32.dll' name 'glColorFormatNV';
    
    static procedure IndexFormatNV(&type: UInt32; stride: Int32);
    external 'opengl32.dll' name 'glIndexFormatNV';
    
    static procedure TexCoordFormatNV(size: Int32; &type: UInt32; stride: Int32);
    external 'opengl32.dll' name 'glTexCoordFormatNV';
    
    static procedure EdgeFlagFormatNV(stride: Int32);
    external 'opengl32.dll' name 'glEdgeFlagFormatNV';
    
    static procedure SecondaryColorFormatNV(size: Int32; &type: UInt32; stride: Int32);
    external 'opengl32.dll' name 'glSecondaryColorFormatNV';
    
    static procedure FogCoordFormatNV(&type: UInt32; stride: Int32);
    external 'opengl32.dll' name 'glFogCoordFormatNV';
    
    static procedure VertexAttribFormatNV(index: UInt32; size: Int32; &type: UInt32; normalized: GLboolean; stride: Int32);
    external 'opengl32.dll' name 'glVertexAttribFormatNV';
    
    static procedure VertexAttribIFormatNV(index: UInt32; size: Int32; &type: UInt32; stride: Int32);
    external 'opengl32.dll' name 'glVertexAttribIFormatNV';
    
    static procedure GetIntegerui64i_vNV(value: UInt32; index: UInt32; result: ^UInt64EXT);
    external 'opengl32.dll' name 'glGetIntegerui64i_vNV';
    
    static procedure ViewportSwizzleNV(index: UInt32; swizzlex: UInt32; swizzley: UInt32; swizzlez: UInt32; swizzlew: UInt32);
    external 'opengl32.dll' name 'glViewportSwizzleNV';
    
    static procedure FramebufferTextureMultiviewOVR(target: UInt32; attachment: UInt32; texture: UInt32; level: Int32; baseViewIndex: Int32; numViews: Int32);
    external 'opengl32.dll' name 'glFramebufferTextureMultiviewOVR';
    
  end;

end.