//
//  ColorSpinnerView.swift
//  Triangle
//
//  Created by William Wold on 1/30/17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import UIKit
import GLKit

class WidapGLView: GLKView {
	
	let vertShaderSrc =
		"attribute vec4 a_Position;         " +
			"void main(void) {                  " +
			"    gl_Position = a_Position;      " +
	"}"
	
	let fragShaderSrc =
		"void main(void) {                       " +
			"    gl_FragColor = vec4(0, 1, 1, 1);    " +
	"}"
	
	let vertices : [Vertex] = [
		Vertex( 0.0,  0.25, 0.0),    // TOP
		Vertex(-0.5, -0.25, 0.0),    // LEFT
		Vertex( 0.5, -0.25, 0.0),    // RIGHT
	]
	
	fileprivate var object = Shape()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		
		backgroundColor = UIColor.clear
		self.isOpaque = false
		
		self.context = EAGLContext(api: .openGLES2)
		EAGLContext.setCurrent(self.context)
		
		object = Shape(verts: vertices, shader: ShaderProgram(vert: vertShaderSrc, frag: fragShaderSrc))
	}
	
	override func draw(_ rect: CGRect) {
		
		print("OpenGL spinner view drawn")
		
		glClearColor(0.0, 0.0, 1.0, 0.5);
		glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
		
		object.draw()
	}
	
	func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer {
		let ptr: UnsafeRawPointer? = nil
		return ptr! + n * MemoryLayout<Void>.size
	}
}

fileprivate class Shape {
	
	var vertexBuffer : GLuint = 0
	var shader = ShaderProgram()
	
	init() {}
	
	init(verts: [Vertex], shader: ShaderProgram) {
		
		self.shader = shader
		
		glGenBuffers(GLsizei(1), &vertexBuffer)
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
		let count = verts.count
		let size =  MemoryLayout<Vertex>.size
		glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, verts, GLenum(GL_STATIC_DRAW))
	}
	
	func draw() {
		
		shader.use()
		
		glEnableVertexAttribArray(VertexAttributes.pos.rawValue)
		
		glVertexAttribPointer(
			VertexAttributes.pos.rawValue,
			3,
			GLenum(GL_FLOAT),
			GLboolean(GL_FALSE),
			GLsizei(MemoryLayout<Vertex>.size),
			nil
		)
		
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
		glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
		
		glDisableVertexAttribArray(VertexAttributes.pos.rawValue)
	}
}

/*
fileprivate class FullRect: Shape {
	
	static let vertices : [Vertex] = [
		Vertex( 1.0, -1.0, 0, 1.0, 0.0, 0.0, 1.0),
		Vert( 1.0,  1.0, 0, 0.0, 1.0, 0.0, 1.0),
		Vertex(-1.0,  1.0, 0, 0.0, 0.0, 1.0, 1.0),
		Vertex(-1.0, -1.0, 0, 1.0, 1.0, 0.0, 1.0)
	]
	
	static let indices : [GLubyte] = [
		0, 1, 2,
		2, 3, 0
	]
	
	init(shader: ShaderProgram) {
		
		super.init(shader: shader)
	}
}
*/


