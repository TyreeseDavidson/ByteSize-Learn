import SwiftUI

struct HomePageView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State private var courses: [Course] = []
    @State private var showDropdown = false

    var body: some View {
        ZStack {
            // Vibrant gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.indigo.opacity(0.6), Color.cyan.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 40) {
                // Title with modern typography
                TypingTextView(text: "Learn Something New Today!")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 80)

                // Scrollable list of full-width cards
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(courses, id: \.id) { course in
                            CourseCardView(course: course) {
                                coordinator.push(.learning(course: course))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                Spacer()
            }
            .onAppear { loadCourses() }
            .navigationBarHidden(true)

            DropdownMenu(showDropdown: $showDropdown, coordinator: coordinator)
        }
    }

    private func loadCourses() {
        courses = CourseCache.shared.loadCourses()
    }
}

// MARK: - CourseCardView with Clean and Full-Width Design
struct CourseCardView: View {
    let course: Course
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                // Gradient text for course name
                Text(course.name)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Dropdown Menu Component
struct DropdownMenu: View {
    @Binding var showDropdown: Bool
    var coordinator: Coordinator

    var body: some View {
        VStack {
            Button(action: toggleDropdown) {
                Image(systemName: showDropdown ? "xmark.circle.fill" : "line.3.horizontal.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .padding()
            }
            .buttonStyle(PlainButtonStyle())

            if showDropdown {
                VStack(alignment: .leading, spacing: 20) {
                    DropdownButton(title: "About", icon: "info.circle", showDropdown: $showDropdown) {
                        coordinator.push(.about)
                    }
                    DropdownButton(title: "Settings", icon: "gearshape.fill", showDropdown: $showDropdown) {
                        coordinator.push(.settings)
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.leading, 16)
                .padding(.top, 60)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            showDropdown ? Color.black.opacity(0.6).ignoresSafeArea().onTapGesture {
                withAnimation { showDropdown = false }
            } : nil
        )
    }

    private func toggleDropdown() {
        withAnimation(.easeInOut) { showDropdown.toggle() }
        if showDropdown { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    }
}

// MARK: - DropdownButton Component
struct DropdownButton: View {
    var title: String
    var icon: String?
    @Binding var showDropdown: Bool
    var action: () -> Void

    var body: some View {
        GeometryReader { geometry in
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.leading, 8)

                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.3))
            .cornerRadius(12)
            .frame(maxWidth: geometry.size.width - 32)  // Ensures the button stays within the screen bounds
            .onTapGesture {
                action()
                withAnimation { showDropdown = false }
            }
            .scaleEffect(showDropdown ? 1.05 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0))
        }
        .frame(height: 50)  // Set a fixed height for the button
    }
}
